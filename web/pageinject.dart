
import 'dart:html';

Function passwordBoxFiller(InputElement passwordBox){
  return (event) => passwordBox.value = "Password1";//TODO(drt24) Use passgori to do the filling
}

void main() {
  List<InputElement> inputElements = queryAll('input');
  List<InputElement> passwordElements = new List<InputElement>();
  for (InputElement element in inputElements) {
    if (element.attributes['type'] == 'password') {
      passwordElements.add(element);
      }
    }
  for (InputElement passwordBox in passwordElements){
    ButtonElement button = new ButtonElement();
    button.text = '*';
    button.on.click.add(passwordBoxFiller(passwordBox));
    passwordBox.insertAdjacentElement('afterend', button);
  }
}
class Pageinject {
  
}
