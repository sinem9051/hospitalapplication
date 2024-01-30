import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

void sendMail() async {
  // Mail ayarları
  String username = 'myemail@gmail.com'; // Gmail hesap kullanıcı adı
  String password = 'mypassword'; // Gmail hesap parolası
  String recipient = 'recipient@gmail.com'; // Alıcının e-posta adresi

  // SMTP sunucusu ayarları
  final smtpServer = gmail(username, password);

  // Mail oluşturma
  final message = Message()
    ..from = Address(username, 'My Name') // Gönderenin ismi ve e-posta adresi
    ..recipients.add(recipient) // Alıcının e-posta adresi
    ..subject = 'Test Mail' // E-posta konusu
    ..text = 'This is a test mail.'; // E-posta içeriği

  try {
    // Maili gönder
    final sendReport = await send(message, smtpServer);
    print('Mail gönderildi: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Hata: ${e.message}');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}