

import '../../../core/resources/data_state.dart';
import '../../../core/use_cases/use_case.dart';
import '../repositories/local_storage_repository.dart';

class DeleteLocalStorageLoginUseCase extends UseCase<DataState<String?>, String> {
  LocalStorageNewsRepository localStorageLoginRepository;

  DeleteLocalStorageLoginUseCase(this.localStorageLoginRepository);

  @override
  Future<DataState<String?>> call(String param) async {
    return await localStorageLoginRepository.deleteStorageData(param);
  }
}
