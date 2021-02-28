import 'dart:collection';

class Stack<T> {
  final _stack = Queue<T>();

  void push(T element) {
    _stack.addLast(element);
  }

  T peek() {
    final T lastElement = _stack.last;
    return lastElement;
  }

  T pop() {
    if(_stack.isNotEmpty) {
      final T lastElement = _stack.last;
      _stack.removeLast();
      return lastElement;
    }
  }

  void clear() {
    _stack.clear();
  }

  bool moreThanOneRemaining(){
    int len=_stack.length;

    return len>1;
  }

  bool get isEmpty => _stack.isEmpty;
}