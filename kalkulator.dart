// Kalkulator konsol sederhana
// Cara pakai:
//  - Jalankan: dart run kalkulator.dart
//  - Masukkan operasi dalam bentuk: 3 + 4
//    atau: 12.5 * 2
//  - Operator yang didukung: +  -  *  /  %  ^ (pangkat)
//  - Ketik 'q' atau 'quit' untuk keluar

import 'dart:io';
import 'dart:math';

final Map<String, int> _prec = {'+': 2, '-': 2, '*': 3, '/': 3, '%': 3, '^': 4};
final Set<String> _ops = {'+', '-', '*', '/', '%', '^'};

List<String> _tokenize(String s) {
	s = s.replaceAll(' ', '');
	List<String> out = [];
		int i = 0;
	while (i < s.length) {
		String ch = s[i];
		if (ch == '+' || ch == '*' || ch == '/' || ch == '%' || ch == '^' || ch == '(' || ch == ')') {
			out.add(ch);
			i++;
			continue;
		}
		if (ch == '-') {
			bool unary = i == 0 || _ops.contains(s[i - 1]) || s[i - 1] == '(';
			if (unary) {
				out.add('0');
			}
			out.add('-');
			i++;
			continue;
		}
		// number
		if (RegExp(r'\d').hasMatch(ch) || ch == '.') {
			int j = i + 1;
			while (j < s.length && (RegExp(r'\d').hasMatch(s[j]) || s[j] == '.')) j++;
			out.add(s.substring(i, j));
			i = j;
			continue;
		}
		// unknown char -> skip
		i++;
	}
	return out;
}

List<String> _toRPN(List<String> tokens) {
	List<String> output = [];
	List<String> stack = [];
	for (var t in tokens) {
		if (t.isEmpty) continue;
		if (RegExp(r'^\d+(?:\.\d+)?$').hasMatch(t)) {
			output.add(t);
		} else if (_ops.contains(t)) {
			while (stack.isNotEmpty && _ops.contains(stack.last)) {
				String o2 = stack.last;
				int p1 = _prec[t]!;
				int p2 = _prec[o2]!;
				bool rightAssoc = t == '^';
				if ((rightAssoc && p1 < p2) || (!rightAssoc && p1 <= p2)) {
					output.add(stack.removeLast());
				} else {
					break;
				}
			}
			stack.add(t);
		} else if (t == '(') {
			stack.add(t);
		} else if (t == ')') {
			while (stack.isNotEmpty && stack.last != '(') {
				output.add(stack.removeLast());
			}
			if (stack.isNotEmpty && stack.last == '(') stack.removeLast();
		}
	}
	while (stack.isNotEmpty) output.add(stack.removeLast());
	return output;
}

double? _evalRPN(List<String> rpn) {
	List<double> st = [];
	for (var t in rpn) {
		if (RegExp(r'^\d+(?:\.\d+)?$').hasMatch(t)) {
			st.add(double.parse(t));
		} else if (_ops.contains(t)) {
			if (st.length < 2) return null;
			double b = st.removeLast();
			double a = st.removeLast();
			double res;
			if (t == '+') res = a + b;
			else if (t == '-') res = a - b;
			else if (t == '*' ) res = a * b;
			else if (t == '/') {
				if (b == 0) throw IntegerDivisionByZeroException();
				res = a / b;
			} else if (t == '%') {
				if (b == 0) throw IntegerDivisionByZeroException();
				res = a % b;
			} else if (t == '^') res = pow(a, b).toDouble();
			else return null;
			st.add(res);
		} else return null;
	}
	if (st.length != 1) return null;
	return st.first;
}

String _fmt(num v) {
	if (v is double) {
		if (v.isInfinite) return v.toString();
		if (v == v.toInt()) return v.toInt().toString();
		return v.toString();
	}
	return v.toString();
}

void main(List<String> args) {
	stdout.writeln('=== Kalkulator Keren ===');
	stdout.writeln('Dukungan: + - * / % ^ dan tanda kurung (). Ketik q atau quit untuk keluar.');
	while (true) {
		stdout.write('> ');
		String? line = stdin.readLineSync();
		if (line == null) break;
		line = line.trim();
		if (line.isEmpty) continue;
		if (line.toLowerCase() == 'q' || line.toLowerCase() == 'quit') {
			stdout.writeln('Bye');
			break;
		}
		try {
			var tokens = _tokenize(line);
			if (tokens.isEmpty) {
				stdout.writeln('Input kosong atau tidak valid');
				continue;
			}
			var rpn = _toRPN(tokens);
			var res = _evalRPN(rpn);
			if (res == null) {
				stdout.writeln('Tidak bisa mengevaluasi ekspresi');
				continue;
			}
			stdout.writeln('= ${_fmt(res)}');
		} on IntegerDivisionByZeroException {
			stdout.writeln('Error: pembagian atau modulus dengan nol');
		} catch (e) {
			stdout.writeln('Error: ${e.toString()}');
		}
	}
}

