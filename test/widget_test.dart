import 'package:flutter_test/flutter_test.dart';
import '../lib/views/authenticate/sign_in.dart';
import '../lib/views/home/home.dart';

void main() {

  //******** Se valida el correo en el login ***********
  test('Se espera que si no se ingresa nada al input del correo muestre un mensaje', (){
      var result = EmailFieldValidator.validate('');
      expect(result, 'Ingrese su correo');
  });

  test('Se espera que al ingresar un correo el metodo validate retorne un null', (){
      var result = EmailFieldValidator.validate('correo@prueba.com');
      expect(result, null);
  });

  //********************************************************/

  //******** Se valida la contraseña en el login ***********
  test('Se espera que si no se ingresa nada al input del password muestre un mensaje', () {
      var result = PasswordFieldValidator.validate('');
      expect(result, 'Ingrese su contraseña');
  });

  test('Se espera que al ingresar una contraseña el metodo validate retorne un null', (){
      var result = EmailFieldValidator.validate('contraseñasegura');
      expect(result, null);
  });

  //********************************************************/


  //************ Validación del API ************************/
  test('Se espera que el response tenga un status code 200', () async{

      var result = getData(); // Instanciamos la clase getData en el primer resultado

      var newResult = await result.getStatusCode("https://api.itbook.store/1.0/search/mongodb"); // Fetcheamos el resultado esperando un true

      expect(newResult, true); // Se espera el resultado
  });

}
