import 'package:flutter/material.dart';
import 'package:seg/services/auth_service.dart';

showConfirmPasswordDialog(
    {required BuildContext context, required String email}) {
  showDialog(
      context: context,
      builder: (context) {
        TextEditingController confirmPasswordDelete = TextEditingController();
        return AlertDialog(
          title: Text("Deseja remover a conta $email?"),
          content: SizedBox(
            height: 175,
            child: Column(
              children: [
                const Text("Para confirmar a exclusão da conta insira sua senha:"),
                TextFormField(
                  controller: confirmPasswordDelete,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () {
              AuthService().apagarConta(senha: confirmPasswordDelete.text).then((String? erro) {
                if (erro == null) {
                  Navigator.pop(context);
                }
              });
            }, child: const Text("EXCLUIR CONTA"))
          ],
        );
      });
}
