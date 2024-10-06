import 'package:flutter/material.dart';
import 'package:mica/widget/custom_app_bars/custom_back_bar_doc.dart';

class TermsScreensGoogle extends StatelessWidget {
  const TermsScreensGoogle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomBackBarDoc(
        route: "signup_google",
        text: "Términos y condiciones",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSection(
              context,
              "1. Aceptación de los Términos",
              "Al utilizar Mica, nuestra aplicación de sorteos, usted acepta los presentes términos y condiciones. Si no está de acuerdo con alguno de estos términos, no debe utilizar la aplicación. Nos reservamos el derecho de modificar estos términos en cualquier momento, y dichos cambios serán efectivos inmediatamente después de su publicación en la aplicación. Es su responsabilidad revisar periódicamente estos términos.",
            ),
            _buildSection(
              context,
              "2. Elegibilidad",
              "Para participar en los sorteos ofrecidos a través de la aplicación, debe ser mayor de 18 años y residir legalmente en la República Bolivariana de Venezuela. Se requerirá una verificación de identidad para poder reclamar cualquier premio. La participación está prohibida para empleados, directores y familiares directos de los organizadores de los sorteos.",
            ),
            _buildSection(
              context,
              "3. Registro y Cuenta",
              "Para utilizar la aplicación, debe registrarse proporcionando información verdadera, precisa y completa. Usted es responsable de mantener la confidencialidad de su cuenta, contraseña y de todas las actividades que ocurran bajo su cuenta.",
            ),
            _buildSubsection(
              context,
              "3.1 Provisión de Fotografía",
              "Para validar la identidad de los participantes y garantizar que cada persona registrada sea real, el organizador solicitará una fotografía del usuario donde se vea claramente su rostro. La fotografía debe ser nítida, reciente, y mostrar el rostro descubierto del participante mirando a la cámara.",
              "El no proporcionar la fotografía solicitada al registrar tu usuario resultará en la imposibilidad de participar en el sorteo. En caso de resultar ganador, el usuario deberá proporcionar su identificación para confirmar su identidad y verificar que la fotografía del usuario y la de la Cédula de Identidad coincidan.",
              "La información personal y las fotografías proporcionadas serán utilizadas exclusivamente para la validación de identidad y la administración del concurso. El organizador se compromete a tratar la información personal de los participantes conforme a la legislación vigente en Venezuela, especialmente la Ley de Protección de Datos Personales y otras normativas aplicables.",
            ),
            _buildSection(
              context,
              "4. Participación en Sorteos",
              "La participación en sorteos está sujeta a las reglas específicas de cada evento, que serán publicadas junto con el anuncio correspondiente. Las entradas a los sorteos pueden ser limitadas por usuario, y cualquier intento de manipulación será penalizado con la descalificación inmediata.",
            ),
            _buildSection(
              context,
              "5. Política de No Reembolsos",
              "Los participantes deben estar completamente seguros de querer participar antes de comprar el número del sorteo, ya que una vez se haya adquirido el número, no se realizarán reembolsos ni devoluciones bajo ningún concepto. Esta política de no reembolsos ni devoluciones está avalada por las leyes de Venezuela relativas a sorteos y juegos de azar, incluyendo la Ley de Juegos de Envite y Azar y sus regulaciones complementarias.",
              "Conforme a la Ley de Juegos de Envite y Azar de Venezuela, los pagos realizados para la participación en sorteos se consideran definitivos y no están sujetos a reembolsos una vez completados, debido a la naturaleza del contrato de participación en juegos de azar. Esta disposición asegura la integridad del proceso y la equidad del concurso, protegiendo tanto a los participantes como al organizador de reclamaciones indebidas.",
              "Los participantes aceptan que, al comprar un número del sorteo, están celebrando un contrato irrevocable de participación en el juego de azar, conforme a las regulaciones vigentes.",
            ),
            _buildSection(
              context,
              "6. Selección de Ganadores",
              "Los ganadores serán seleccionados de manera aleatoria mediante un proceso automatizado certificado. Los resultados serán publicados en la aplicación y los ganadores serán notificados por correo electrónico y/o notificación en la aplicación. Nos reservamos el derecho de realizar verificaciones adicionales de identidad y cumplimiento de las reglas antes de declarar oficialmente a un ganador.",
              "Al resultar ganador, aceptas que Mica difunda y realice fotos y videos en sus medios de comunicación del ganador/a y la entrega del premio.",
            ),
            _buildSection(
              context,
              "7. Reclamación de Premios",
              "Los premios deben ser reclamados dentro del plazo especificado en el anuncio del ganador. El ganador dispondrá de 15 días para reclamar el premio, en caso de no reclamarlo dentro del plazo establecido, se considerará renunciado y se elegirá a otro ganador en su lugar.",
              "Para reclamar un premio, se requerirá una identificación válida y, en algunos casos, documentación adicional que respalde la elegibilidad y cumplimiento de estos términos.",
              "El premio debe ser reclamado personalmente en el lugar indicado en cada sorteo.",
            ),
            _buildSection(
              context,
              "8. Impuestos y Retenciones",
              "Los premios están sujetos a impuestos y retenciones conforme a la legislación venezolana vigente. Los ganadores son responsables de declarar y pagar cualquier impuesto aplicable. Nos reservamos el derecho de retener cualquier impuesto requerido por ley antes de la entrega del premio.",
            ),
            _buildSection(
              context,
              "9. Privacidad y Protección de Datos Personales",
              "La información personal proporcionada será tratada conforme a nuestra Política de Privacidad de datos, la cual cumple con las regulaciones de protección de datos personales en la República Bolivariana de Venezuela. Al utilizar la aplicación, usted consiente en la recopilación, uso y tratamiento de su información personal según se describe en dicha política. No compartiremos su información personal con terceros sin su consentimiento, salvo por ciertos requerimientos (punto 3. Compartición de la Información de política de privacidad de datos).",
            ),
            _buildSection(
              context,
              "10. Uso Aceptable",
              "Usted se compromete a utilizar la aplicación de manera legal y conforme a estos términos. Está prohibido intentar manipular, hackear, alterar o interferir con el funcionamiento de la aplicación o los sorteos. Cualquier conducta fraudulenta será reportada a las autoridades competentes y resultará en la descalificación y posible acción legal.",
            ),
            _buildSection(
              context,
              "11. Limitación de Responsabilidad",
              "Nos esforzamos por mantener la aplicación operativa y libre de errores, pero no garantizamos que siempre esté disponible o libre de fallos. No nos hacemos responsables por errores técnicos, problemas de conexión, fallos del sistema, intervenciones no autorizadas, fraude, o cualquier otra circunstancia fuera de nuestro control que pueda afectar la participación en los sorteos o la entrega de premios.",
            ),
            _buildSection(
              context,
              "12. Propiedad Intelectual",
              "Todo el contenido de la aplicación, incluidos textos, gráficos, logotipos, imágenes y software, es propiedad de Cents Company o de sus proveedores de contenido y está protegido por leyes de derechos de autor y de propiedad intelectual. No se permite la reproducción, distribución, modificación o uso no autorizado de dicho contenido.",
            ),
            _buildSection(
              context,
              "13. Modificaciones de los Términos",
              "Nos reservamos el derecho de modificar estos términos y condiciones en cualquier momento. Las modificaciones entrarán en vigor al ser publicadas en la aplicación. Es su responsabilidad revisar periódicamente estos términos para estar informado de cualquier cambio.",
            ),
            _buildSection(
              context,
              "14. Ley Aplicable y Jurisdicción",
              "Estos términos y condiciones se rigen por las leyes de la República Bolivariana de Venezuela. Cualquier disputa que surja en relación con estos términos se resolverá exclusivamente en los tribunales competentes de la República Bolivariana de Venezuela.",
            ),
            _buildSection(
              context,
              "15. Contacto",
              "Para cualquier pregunta, comentario o inquietud sobre estos términos y condiciones, puede contactarnos a través del correo electrónico:",
              "soporte@centscompany.com",
              "o a través de la sección de contacto en la aplicación.",
            ),
            _buildFinalNote(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    String content1, [
    String? content2,
    String? content3,
  ]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
          textAlign: TextAlign.justify,
        ),
        const SizedBox(height: 8),
        Text(
          content1,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 16,
              ),
          textAlign: TextAlign.justify,
        ),
        if (content2 != null) ...[
          const SizedBox(height: 8),
          Text(
            content2,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 16,
                ),
            textAlign: TextAlign.justify,
          ),
        ],
        if (content3 != null) ...[
          const SizedBox(height: 8),
          Text(
            content3,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 16,
                ),
            textAlign: TextAlign.justify,
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSubsection(
    BuildContext context,
    String title,
    String content1,
    String content2,
    String content3,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
          textAlign: TextAlign.justify,
        ),
        const SizedBox(height: 8),
        Text(
          content1,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 16,
              ),
          textAlign: TextAlign.justify,
        ),
        const SizedBox(height: 8),
        Text(
          content2,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 16,
              ),
          textAlign: TextAlign.justify,
        ),
        const SizedBox(height: 8),
        Text(
          content3,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 16,
              ),
          textAlign: TextAlign.justify,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFinalNote(BuildContext context) {
    return Text(
      "Al hacer clic en 'Aceptar', usted confirma que ha leído, comprendido y aceptado estos términos y condiciones.",
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
      textAlign: TextAlign.center,
    );
  }
}
