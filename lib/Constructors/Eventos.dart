class Eventos {
  final String deporte, local, visitante, resultado;

  Eventos({this.deporte, this.local, this.visitante, this.resultado});

  factory Eventos.fromJson(Map<String, dynamic> jsonData) {
    return Eventos(
      deporte: jsonData['Deporte'],
      local: jsonData['Local'],
      visitante: jsonData['Visitante'],
      resultado: jsonData['Resultado'],
    );
  }
}
