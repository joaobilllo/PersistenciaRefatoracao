import 'package:flutter/material.dart';
import 'package:exemplo/domain/models/pessoa.dart';
import 'package:exemplo/presentation/stores/pessoa_store.dart';
import 'package:exemplo/core/di/service_locator.dart';

class PessoasPage extends StatefulWidget {
  const PessoasPage({super.key});

  @override
  State<PessoasPage> createState() => _PessoasPageState();
}

class _PessoasPageState extends State<PessoasPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();

  late final PessoaStore _store;
  int? _editingId;

  @override
  void initState() {
    super.initState();
    _store = ServiceLocator.get<PessoaStore>();
    _store.addListener(_onStoreChanged);
  }

  @override
  void dispose() {
    _store.removeListener(_onStoreChanged);
    _nomeController.dispose();
    _idadeController.dispose();
    super.dispose();
  }

  void _onStoreChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _nomeController.clear();
    _idadeController.clear();
    _editingId = null;
    FocusScope.of(context).unfocus();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_store.isSaving) return;

    final nome = _nomeController.text.trim();
    final idade = int.parse(_idadeController.text.trim());
    final pessoa = Pessoa(id: _editingId, nome: nome, idade: idade);

    final result = _editingId == null
        ? await _store.createPessoa(pessoa)
        : await _store.updatePessoa(pessoa);

    if (mounted && result.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _editingId == null
                ? 'Pessoa adicionada com sucesso!'
                : 'Pessoa atualizada com sucesso!',
          ),
          backgroundColor: Colors.green,
        ),
      );
      _clearForm();
    } else if (mounted && result.isFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message ?? 'Erro desconhecido'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _delete(int id, String nome) async {
    final confirmed = await _showDeleteConfirmation(nome);
    if (!confirmed) return;

    final result = await _store.deletePessoa(id);
    if (mounted) {
      if (result.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pessoa removida com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        if (_editingId == id) {
          _clearForm();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message ?? 'Erro ao remover pessoa'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<bool> _showDeleteConfirmation(String nome) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirmar exclusão'),
            content: Text('Deseja realmente remover "$nome"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Remover'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _editPessoa(Pessoa pessoa) {
    setState(() {
      _editingId = pessoa.id;
      _nomeController.text = pessoa.nome;
      _idadeController.text = pessoa.idade.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _editingId != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pessoas (SQLite)'),
        actions: [
          IconButton(
            tooltip: 'Recarregar',
            onPressed: _store.loadPessoas,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Form Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildForm(isEditing),
            ),
            const Divider(height: 1),
            // List Section
            Expanded(child: _buildPessoasList()),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(bool isEditing) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nomeController,
            decoration: const InputDecoration(
              labelText: 'Nome',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Por favor, informe o nome';
              }
              if (value.trim().length < 2) {
                return 'Nome deve ter pelo menos 2 caracteres';
              }
              if (value.trim().length > 100) {
                return 'Nome não pode ter mais de 100 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _idadeController,
            decoration: const InputDecoration(
              labelText: 'Idade',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _save(),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Por favor, informe a idade';
              }
              final idade = int.tryParse(value.trim());
              if (idade == null || idade < 0 || idade > 150) {
                return 'Idade deve estar entre 0 e 150 anos';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _store.isSaving ? null : _save,
                  icon: _store.isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(isEditing ? Icons.save : Icons.add),
                  label: Text(isEditing ? 'Salvar alterações' : 'Adicionar'),
                ),
              ),
              if (isEditing) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _clearForm,
                    icon: const Icon(Icons.close),
                    label: const Text('Cancelar'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPessoasList() {
    if (_store.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_store.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Erro: ${_store.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  _store.clearError();
                  _store.loadPessoas();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (_store.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.people_outline, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Nenhuma pessoa cadastrada',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _store.pessoas.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final pessoa = _store.pessoas[index];
        final isCurrentlyEditing = _editingId == pessoa.id;

        return Card(
          elevation: isCurrentlyEditing ? 4 : 1,
          color: isCurrentlyEditing
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
          child: ListTile(
            title: Text(
              pessoa.nome,
              style: TextStyle(
                fontWeight: isCurrentlyEditing ? FontWeight.bold : null,
              ),
            ),
            subtitle: Text('${pessoa.idade} anos • ID: ${pessoa.id}'),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    _editPessoa(pessoa);
                    break;
                  case 'delete':
                    _delete(pessoa.id!, pessoa.nome);
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text('Editar'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Excluir', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () => _editPessoa(pessoa),
          ),
        );
      },
    );
  }
}
