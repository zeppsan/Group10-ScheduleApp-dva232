import 'package:get_it/get_it.dart';
import 'package:schedule_dva232/map/core/util/input_converter.dart';
import 'package:schedule_dva232/map/data_domain/repositories/building_repository.dart';
import 'package:schedule_dva232/map/data_domain/usecases/get_building_usecase.dart';
import 'package:schedule_dva232/map/data_domain/usecases/get_room_list_usecase.dart';
import 'package:schedule_dva232/map/presentation/browsing_ploc/browsing_logic.dart';
import 'package:schedule_dva232/map/presentation/searching_ploc/searching_logic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'map/data_domain/repositories/room_repository.dart';
import 'map/data_domain/usecases/get_room_usecase.dart';

final serviceLocator = GetIt.instance;
Future<void> init () async
{
  //Ploc
  //Instantiates new instance on every call
  serviceLocator.registerFactory(() => BrowsingLogic(getBuilding: serviceLocator(),getRoom: serviceLocator(), inputConverter: serviceLocator()));
  serviceLocator.registerFactory(() => SearchingLogic(getRoom: serviceLocator(), inputConverter: serviceLocator()));

  //Usecases
  //Get it caches this and gives the same instance every time
  //Lazy is instantiated when called
  serviceLocator.registerLazySingleton(() => GetBuilding(serviceLocator()));
  serviceLocator.registerLazySingleton(()=> GetRoom(serviceLocator()));
  serviceLocator.registerLazySingleton(()=> GetRoomList(serviceLocator()));

  //Repositories
  serviceLocator.registerLazySingleton<BuildingRepository>(() => BuildingRepositoryImpl(
      assetsDataSource: serviceLocator()
    )
  );
  serviceLocator.registerLazySingleton<RoomRepository>(() => RoomRepositoryImpl(
      assetsDataSource: serviceLocator()
    )
  );

  serviceLocator.registerLazySingleton<BuildingAssetsDataSource>(() =>
      BuildingAssetsDataSourceImpl(),
  );

  serviceLocator.registerLazySingleton<RoomAssetsDataSource>(() =>
      RoomAssetsDataSourceImpl(),
  );

  //Input converter
  serviceLocator.registerLazySingleton(() => InputConverter());

  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);
}
