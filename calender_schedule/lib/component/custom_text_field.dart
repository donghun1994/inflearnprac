import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../const/const.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isTime;
  final FormFieldSetter<String> onSaved;

  const CustomTextField({Key? key, required this.label, required this.isTime, required this.onSaved})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              color: PRIMARY_COLOR,
              fontWeight: FontWeight.w600,
            )),
        if (isTime) renderTextField(),
        if (!isTime)
          Expanded(
            child: renderTextField(),
          ),
      ],
    );
  }

  Widget renderTextField() {
    return TextFormField(
      onChanged: (String? value) {
        // textfield의 값을 다 받는 항목
        //근데 텍스트 필드가 지금 3개를 따로 받아야 함;;
        //그래서 Form 이라는걸 써서 한 번에 필드를 관리할 수 있음
        //이걸 쓰려면 TextFormField를 쓰면 됨, TextField 보다 더 많은 걸 제공,
        // onChanged도 안씀
      },

      //validator null이 return 되면 에러가 없다.
      // 에러가 있으면 에러를 String 값으로 리턴해준다.
      //TextFormField를 관리하려는 상위의 위젯을 Form으로 감싸줘야함!
      validator: (String? val){
        if(val==null|| val.isEmpty){
          return '값을 입력해주세요';
        }
        if(isTime){
          int time = int.parse(val); //input에서 숫자로만 제한해놔서 무조건 int만 들어오긴함
          if(time <0){
            return '0 이상의 숫자를 입력해주세요.';
          }

          if(time>24){
            return '24 이하의 숫자를 입력해주세요.';
          }
        }else{
          if(val.length>500){
            return '500자 이하의 글자를 입력해주세요.';
          }
        }
          return null;
      },
      // onsaved는 validator 끝나고 Textformfiled를 감싸고 있는 상위의
      // Form에서 save()가 불렸을 때 실행됨
      onSaved: onSaved ,
      maxLines: isTime ? 1 : null,
      expands: !isTime,
      keyboardType: isTime ? TextInputType.number : TextInputType.multiline,
      inputFormatters: isTime
          ? [
              // input 박스에서 숫자만 입력하게 제한하는 것!!
              FilteringTextInputFormatter.digitsOnly,
            ]
          : [],
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey[300],
      ),
    );
  }
}
