import 'package:supabase/supabase.dart';
import '../models/ingrediente.dart';
import '../models/receita.dart';

class BancoService {
  static final SupabaseClient _db = SupabaseClient(
    'https://ocoppjobnylcmfvggwbz.supabase.co',
    'sb_publishable_9XTb3hBP1wXTc4FtR4OSgg_EeKg_6Nu',
  );

  // RECEITAS

  Future<List<Receita>> listarReceitas() async {
    final dados = await _db
        .from('receitas')
        .select('id, nome, ingredientes(count)')
        .order('created_at');
    return dados.map<Receita>((m) => Receita.fromMap(m)).toList();
  }

  Future<Receita> criarReceita(String nome) async {
    final dado = await _db
        .from('receitas')
        .insert({'nome': nome})
        .select()
        .single();
    return Receita.fromMap(dado);
  }

  Future<void> removerReceita(int id) async {
    // Os ingredientes são apagados junto (on delete cascade no banco).
    await _db.from('receitas').delete().eq('id', id);
  }

  // INGREDITES
  Future<List<Ingrediente>> listarIngredientes(int receitaId) async {
    final dados = await _db
        .from('ingredientes')
        .select()
        .eq('receita_id', receitaId)
        .order('created_at');
    return dados.map<Ingrediente>((m) => Ingrediente.fromMap(m)).toList();
  }

  Future<Ingrediente> adicionarIngrediente(Ingrediente ingrediente) async {
    final dado = await _db
        .from('ingredientes')
        .insert(ingrediente.toMap())
        .select()
        .single();
    return Ingrediente.fromMap(dado);
  }

  Future<void> removerIngrediente(int id) async {
    await _db.from('ingredientes').delete().eq('id', id);
  }
}
