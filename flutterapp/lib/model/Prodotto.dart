import 'dart:convert';

import 'package:object_mapper/object_mapper.dart';

/**
 * Classe che modella il concetto di prodotto
 */
class Prodotto {
  String nome;
  String categoria;
  String quantita;
  String note;
  String iduser;
  String nomeutente;
  String buy;

  /**
   * Costruttore
   */
  Prodotto(

      this.nome,
      this.categoria,
      this.quantita,
      this.note,
      this.iduser,
      this.nomeutente,
      this.buy);

  // Constructor, with syntactic sugar for assignment to members.

  Map<String, dynamic> toJson() =>
      {
        'nome': nome,
        'categoria': categoria,
        'quantita': quantita,
        'note': note,
        'iduser': iduser,
        'nomeutente': nomeutente,
        'buy': buy,

      };


  /**
   * Funzione per effettuare il mapping da json a oggetto Prodotto
   */
  factory Prodotto.fromJson(dynamic json){
    return Prodotto(json['nome'] as String,
                   json['categoria'] as String,
                  json['quantita'] as String,
                  json['note'] as String,
                  json['iduser'] as String,
                  json['nomeutente'] as String,
                  json['buy'] as String);
  }
}
