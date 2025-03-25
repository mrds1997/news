
import '../../../core/params/write_localstorage_param.dart';
import '../../../core/resources/data_state.dart';
import '../../../core/use_cases/use_case.dart';
import '../repositories/local_storage_repository.dart';

class WriteLocalStorageCreditCardUseCase
    extends UseCase<DataState<String?>, WriteLocalStorageParam> {
  LocalStorageNewsRepository localStorageLoginRepository;

  WriteLocalStorageCreditCardUseCase(this.localStorageLoginRepository);

  @override
  Future<DataState<String?>> call(WriteLocalStorageParam param) async {
    return await localStorageLoginRepository.writeStorageData(param);
  }
}
