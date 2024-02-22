// import 'package:alfi_gest/helpers/result.dart';
// import 'package:alfi_gest/models/enums.dart';
// import 'package:alfi_gest/models/member.dart';
// import 'package:alfi_gest/models/user_role.dart';
// import 'package:alfi_gest/services/member_service.dart';
// import 'package:flutter_test/flutter_test.dart';

// void main() {
//   // Crea un oggetto `MemberService`
//   final memberService = MemberService();

//   // Esegue il test della funzione `getMember()` con un ID utente valido
//   final result = await memberService.getMember('1234567890');
//   expect(result.isSuccess(), true);
//   expect(result.hasData, true);
//   expect(result.data!.uid, '1234567890');

//   // Esegue il test della funzione `getMember()` con un ID utente non valido
//   final result2 = await memberService.getMember('0000000000');
//   expect(result2.isSuccess(), false);
//   expect(result2.error, 'Socio non esistente');

//   // Crea un oggetto `Member`
//   final member = Member(
//     uid: '1234567890',
//     name: 'Mario Rossi',
//     surname: 'Verdi',
//     email: 'mario.rossi@example.com',
//   );

//   // Esegue il test della funzione `createMember()` con un membro valido
//   final result3 = await memberService.createMember(member.uid, member);
//   expect(result3.isSuccess(), true);
//   expect(result3.hasData, true);
//   expect(result3.data!.uid, member.uid);
//   expect(result3.data!.name, member.name);
//   expect(result3.data!.surname, member.surname);
//   expect(result3.data!.email, member.email);

//   // Esegue il test della funzione `createMember()` con un membro con campi non validi
//   final member2 = Member(
//     uid: '1234567890',
//     name: '',
//     surname: '',
//     email: '',
//   );
//   final result4 = await memberService.createMember(member2.uid, member2);
//   expect(result4.isSuccess(), false);
//   expect(result4.errors, ['Il campo "name" deve essere valorizzato']);

//   // Aggiorna il nome del membro
//   member.name = 'Giovanni Bianchi';

//   // Esegue il test della funzione `updateMember()`
//   final result5 = await memberService.updateMember(member.uid, member);
//   expect(result5.isSuccess(), true);
//   expect(result5.hasData, true);
//   expect(result5.data!.name, member.name);

//   // Esegue il test della funzione `updateMember()` con un ID utente non valido
//   final result6 = await memberService.updateMember('0000000000', member);
//   expect(result6.isSuccess(), false);
//   expect(result6.error, 'Socio non esistente');
// }
