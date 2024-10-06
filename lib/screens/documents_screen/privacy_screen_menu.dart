import 'package:flutter/material.dart';
import 'package:mica/widget/custom_app_bars/custom_back_bar_doc.dart';

class PrivacyScreenMenu extends StatelessWidget {
  const PrivacyScreenMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomBackBarDoc(
        route: "main",
        text: "Privacidad de datos",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "Fecha de vigencia: 1 de julio de 2024",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              "Introducción",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "En Mica valoramos tu privacidad y nos comprometemos a proteger tus datos personales conforme a las leyes y regulaciones vigentes en la República Bolivariana de Venezuela. Esta Política de Privacidad explica qué información recopilamos, cómo la usamos, con quién la compartimos y tus derechos relacionados con dicha información.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 16,
                  ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            Text(
              "1. Información que Recopilamos",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "Información Personal",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "- Datos de Identificación: Nombre completo, cédula de identidad.\n"
              "- Datos de contacto: Dirección de correo electrónico, número de teléfono.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 16,
                  ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 8),
            Text(
              "Información Técnica",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "- Datos de Uso: Historial de sorteos, tiempo de uso de la app.\n"
              "- Información del Dispositivo: Dirección IP, tipo de dispositivo, sistema operativo, versión de la app.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 16,
                  ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            Text(
              "2. Uso de la Información",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "Utilizamos la información recopilada para los siguientes fines:",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 16,
                  ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 8),
            Text(
              "- Administración de Sorteos y Loterías: Gestionar y operar los sorteos y loterías en los que participas.\n"
              "- Comunicación: Enviarte notificaciones sobre sorteos, promociones y actualizaciones de la app.\n"
              "- Mejora del Servicio: Analizar el uso de la app para mejorar nuestros servicios y la experiencia del usuario.\n"
              "- Seguridad: Proteger contra fraudes y/o estafas y garantizar la seguridad de nuestras plataformas.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 16,
                  ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            Text(
              "3. Compartición de la Información",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "No vendemos ni alquilamos tu información personal. Podemos compartir tus datos con:",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 16,
                  ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 8),
            Text(
              "- Proveedores de Servicios: Terceros que nos ayudan a operar la app, procesar pagos y proporcionar servicios de atención al cliente.\n"
              "- Autoridades Gubernamentales: Cuando sea requerido por ley, reglamento o proceso legal.\n"
              "- Transferencias Comerciales: En caso de fusión, adquisición o venta de activos, tu información puede ser transferida a la nueva entidad.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 16,
                  ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            Text(
              "4. Seguridad de los Datos",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "Implementamos medidas de seguridad administrativas, técnicas y físicas para proteger tu información contra acceso no autorizado, pérdida, uso indebido o divulgación. Sin embargo, no podemos garantizar la seguridad absoluta de tus datos.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 16,
                  ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            Text(
              "5. Retención de Datos",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "Retenemos tus datos personales sólo durante el tiempo necesario para cumplir con los fines descritos en esta Política de Privacidad o según lo requiera la ley.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 16,
                  ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            Text(
              "6. Derechos de los Usuarios",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "De acuerdo con las leyes venezolanas, tienen los siguientes derechos respecto a tus datos personales:",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 16,
                  ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 8),
            Text(
              "- Acceso: Solicitar acceso a tus datos personales que poseemos.\n"
              "- Rectificación: Solicitar la corrección de datos incorrectos o incompletos.\n"
              "- Cancelación: Solicitar la eliminación de tus datos personales, sujeto a ciertas excepciones.\n"
              "- Oposición: Oponerte al procesamiento de tus datos personales bajo ciertas circunstancias.\n"
              "Para ejercer estos derechos, contáctanos a ",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 16,
                  ),
              textAlign: TextAlign.justify,
            ),
            GestureDetector(
              child: Text(
                "soporte@centscompany.com",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 33, 89, 243),
                      decoration: TextDecoration.underline,
                    ),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "7. Cambios a esta Política de Privacidad",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "Nos reservamos el derecho de actualizar esta Política de Privacidad en cualquier momento. Te notificaremos de cualquier cambio mediante la publicación de la nueva política en nuestra app y, si es significativo, te informaremos por correo electrónico.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 16,
                  ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            Text(
              "8. Aceptación de la Política de Privacidad",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "Al utilizar nuestra app, aceptas la Política de Privacidad. Si no estás de acuerdo con esta política, por favor no uses nuestra app.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 16,
                  ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            Text(
              "Mica se compromete a proteger tu privacidad y cumplir con las leyes y regulaciones de la República Bolivariana de Venezuela. Tu confianza es importante para nosotros y nos esforzamos por salvaguardar tu información personal con la mayor diligencia.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 16,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
