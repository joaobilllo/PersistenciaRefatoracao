import 'package:flutter/foundation.dart';
import 'package:exemplo/domain/models/pessoa.dart';
import 'package:exemplo/domain/repositories/pessoa_repository.dart';
import 'package:exemplo/core/result/result.dart';

class PessoaStore extends ChangeNotifier {
  PessoaStore(this._repository) {
    loadPessoas();
  }

  final PessoaRepository _repository;

  List<Pessoa> _pessoas = [];
  bool _isLoading = false;
  String? _error;
  bool _isSaving = false;

  List<Pessoa> get pessoas => List.unmodifiable(_pessoas);
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;
  bool get hasError => _error != null;
  bool get isEmpty => _pessoas.isEmpty && !_isLoading;

  Future<void> loadPessoas() async {
    _setLoading(true);
    _clearError();

    final result = await _repository.getAll();
    result.when(
      success: (pessoas) {
        _pessoas = pessoas;
        _setLoading(false);
      },
      failure: (message, exception) {
        _setError(message);
        _setLoading(false);
      },
    );
  }

  Future<Result<int>> createPessoa(Pessoa pessoa) async {
    _setSaving(true);
    _clearError();

    final result = await _repository.create(pessoa);
    result.when(
      success: (id) {
        _setSaving(false);
        loadPessoas();
      },
      failure: (message, exception) {
        _setError(message);
        _setSaving(false);
      },
    );

    return result;
  }

  Future<Result<int>> updatePessoa(Pessoa pessoa) async {
    _setSaving(true);
    _clearError();

    final result = await _repository.update(pessoa);
    result.when(
      success: (rowsAffected) {
        _setSaving(false);
        loadPessoas();
      },
      failure: (message, exception) {
        _setError(message);
        _setSaving(false);
      },
    );

    return result;
  }

  Future<Result<int>> deletePessoa(int id) async {
    _clearError();

    final result = await _repository.delete(id);
    result.when(
      success: (rowsAffected) {
        loadPessoas();
      },
      failure: (message, exception) {
        _setError(message);
      },
    );

    return result;
  }

  Future<Result<Pessoa?>> getPessoaById(int id) async {
    _clearError();
    final result = await _repository.getById(id);
    
    result.when(
      success: (pessoa) {},
      failure: (message, exception) {
        _setError(message);
      },
    );

    return result;
  }

  Future<Result<bool>> pessoaExists(int id) async {
    return await _repository.exists(id);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setSaving(bool saving) {
    _isSaving = saving;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }

  void clearError() {
    _clearError();
  }
}
