import 'dart:convert';

/**
 * Classe che modella i gruppi
 */
class Gruppo {
  String NomeGruppo;
  Map<String,String> gruppo;

  Gruppo(this.NomeGruppo, this.gruppo);

  Map<String, dynamic> toJson() => {
    "nomeGruppo": NomeGruppo,
  };
}
