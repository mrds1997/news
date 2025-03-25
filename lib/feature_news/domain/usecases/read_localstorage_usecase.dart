

import '../../../core/resources/data_state.dart';
import '../../../core/use_cases/use_case.dart';
import '../repositories/local_storage_repository.dart';

class ReadLocalStorageCreditCardUseCase extends UseCase<DataState<String>, String> {
  LocalStorageNewsRepository localStorageAuthRepository;

  ReadLocalStorageCreditCardUseCase(this.localStorageAuthRepository);
  @override
  Future<DataState<String>> call(String param) async {
    return await localStorageAuthRepository.readStorageData(param);
  }
}
