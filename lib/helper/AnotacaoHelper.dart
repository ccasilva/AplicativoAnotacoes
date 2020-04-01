import 'package:minhas_anotacoes/model/Anotacao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AnotacaoHelper{

  static final String _nomeTabela = "anotacao";
  static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._internal();
  Database _db;

  factory AnotacaoHelper(){
    return _anotacaoHelper;
  }

  AnotacaoHelper._internal(){
  }

  get db async{

    if( _db != null){
      return _db;
    }else{
      _db = await inicializarDB();
      return _db;
    }

  }

  _onCreate(Database db, int version) async {

    String sql = "CREATE TABLE anotacao (id INTEGER PRIMARY KEY AUTOINCREMENT, titulo VARCHAR, descricao  TEXT, data DATETIME )";
    await db.execute(sql);

  }

  inicializarDB() async {

    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join( caminhoBancoDados, "banco_minhas_anotacoes.db" );

    var db = await openDatabase(
      localBancoDados,
      version: 1,
      onCreate: _onCreate
    );
    return db;

  }

  Future<int> salvarAnotacao(Anotacao anotacao) async {

    var bancoDados = await db;
    int resultado = await bancoDados.insert( _nomeTabela, anotacao.toMap() );
    return resultado;

  }

  recuperarAnotacoes() async {

    var bancoDados = await db;
    String sql = "SELECT * FROM $_nomeTabela ORDER BY data DESC";
    List anotacoes = await bancoDados.rawQuery(sql);
    return anotacoes;

  }

  Future<int> atualizarAnotacao(Anotacao anotacao) async{

    var bancoDados = await db;

    int qtdRegistroAlterado = await bancoDados.update(
        _nomeTabela,
        anotacao.toMap(),
        where: "id = ?",
        whereArgs: [anotacao.id] );

    return qtdRegistroAlterado;

  }

  Future<int> removerAnotacao(int id) async{

    var bancoDados = await db;

    int qtdRegistroAlterado = await bancoDados.delete(
        _nomeTabela,
        where: "id = ?",
        whereArgs: [id] );

    return qtdRegistroAlterado;

  }





}