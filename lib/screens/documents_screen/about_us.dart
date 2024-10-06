import 'package:flutter/material.dart';
import 'package:mica/widget/custom_app_bars/custom_back_bar.dart';
import 'package:mica/widget/custom_app_bars/custom_back_bar_doc.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomBackBarDoc(
        text: "Sobre nosotros",
        route: "main",
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "En Mica, buscamos brindar oportunidades reales a personas y familias que desean encontrar su hogar ideal.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.justify),
            SizedBox(height: 16),
            Text(
                "No somos una organización de caridad, sino una plataforma que facilita el acceso a la vivienda de manera novedosa.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify),
            SizedBox(height: 16),
            Text(
                "Creemos en la importancia de que la vivienda sea accesible para todos.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify),
            SizedBox(height: 16),
            Text(
                "Nacimos como respuesta a la creciente crisis de viviendas que afecta a nuestro país, con el objetivo de ofrecer una solución innovadora y justa.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify),
            SizedBox(height: 16),
            Text(
                "Nuestro equipo está compuesto por profesionales comprometidos con el bienestar de nuestra sociedad.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify),
            SizedBox(height: 16),
            Text(
                "Contamos con la experiencia necesaria para hacer realidad este proyecto, que se fundamenta en la transparencia, la equidad y el impacto positivo.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify),
            SizedBox(height: 16),
            Text("Participar con nosotros es más que entrar en un sorteo.",
                style: TextStyle(fontSize: 16), textAlign: TextAlign.justify),
            SizedBox(height: 8),
            Text(
                "Es formar parte de un movimiento que redefine la manera en que entendemos el acceso a la vivienda.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify),
            SizedBox(height: 16),
            Text("Participa y sé parte del cambio.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.justify),
          ],
        ),
      ),
    );
  }
}
