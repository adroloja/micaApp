import 'package:flutter/material.dart';
import 'package:mica/widget/custom_app_bars/custom_back_bar.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomBackBar(
        route: "main",
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildQuestionTile(
              "¿Cómo funciona la app?",
              "Al registrarte y crear tu usuario, podrás acceder a la página principal donde puedes comprar tu número. Al confirmar el pago, te aparecerá el número aleatorio en la pantalla y te llegará un correo automático confirmando la compra y tu número aparece en la sección de números en la esquina inferior izquierda.",
            ),
            _buildQuestionTile(
              "¿Es seguro comprar números en la app?",
              "Si, es completamente seguro comprar un número o más dentro de la aplicación. Tus datos están protegidos por las pasarelas de pagos proporcionada por los bancos y por la ley de protección de datos de la República Bolivariana de Venezuela.",
            ),
            _buildQuestionTile(
              "¿Puedo escoger la ubicación de la vivienda?",
              "No, en caso de resultar ganador no es posible escoger donde estará ubicada la vivienda ya que esto es anunciado al comenzar el sorteo.",
            ),
            _buildQuestionTile(
              "En caso de ganar el sorteo, ¿la vivienda estará a mi nombre?",
              "Si, se realizará la documentación necesaria para que la vivienda esté a nombre del ganador. El tiempo que tarda en estar lista la documentación no depende de nosotros, por lo que no podemos decir con exactitud el tiempo que lleva.",
            ),
            _buildQuestionTile(
              "¿Cuánto tiempo tardan en entregar el premio?",
              "Nuestra intención es entregar la vivienda lo más rápido posible para que el ganador pueda entrar a vivir cuanto antes.",
            ),
            _buildQuestionTile(
              "Si mi amigo gana la vivienda, pero fui yo quien le regaló el número que salió ganador a través de la opción de Regala un Numero ¿la vivienda es mía o de mi amigo?",
              "La vivienda pertenece al número que el algoritmo escoge como ganador. Los números van asociados a un correo electrónico por lo que si el número que resulta ganador fue el que le regalaste a un amigo a través de la opción que facilitamos para ello, tu amigo es el único quien tiene derecho a reclamar el premio.",
            ),
            _buildQuestionTile(
              "¿Cómo se escoge al ganador?",
              "El ganador es seleccionado por un algoritmo diseñado para escoger un número de manera aleatoria entre los números asignados al realizar la compra en el sorteo.",
            ),
            _buildQuestionTile(
              "¿Puedo comprar más de un número?",
              "Si, en la página de inicio en la parte inferior al botón de compra hay una casilla con dos botones para agregar o quitar números y puede comprar tantos como desee, no hay límite de compra por usuario.",
            ),
            _buildQuestionTile(
              "¿Qué ocurre si el ganador no reclama el premio?",
              "Si en el plazo de 10 días hábiles el ganador no reclama la vivienda, el sorteo se realizará nuevamente entre las personas que hayan comprado números del mismo sorteo y se escogerá a un nuevo ganador.",
            ),
            _buildQuestionTile(
              "¿Puedo devolver mis tickets y obtener un reembolso?",
              "No, no es posible devolver los tickets comprados ni obtener reembolsos del mismo.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionTile(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            answer,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ],
    );
  }
}
