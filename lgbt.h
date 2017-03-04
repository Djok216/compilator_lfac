#include <string.h>
struct var {
	int val, tip;
	char name[64];
} v[1024];

int qwen;
char qwe[100][100];

int nr = 0;
int poz = 0;
int sz_buff;
char buff[1024];

void add_buffer(char* name, int val) {
	int i = 0;
	while(name[i]) {
		buff[sz_buff] = name[i];
		++i; ++sz_buff;
	}

	buff[sz_buff] = ' '; ++sz_buff;
	buff[sz_buff] = '='; ++sz_buff;
	buff[sz_buff] = ' '; ++sz_buff;

	if(val < 0) buff[sz_buff] = '-', ++sz_buff, val = -val;

	char aux[20];
	i = 0;
	memset(aux, 0, sizeof(aux));
	while(val) aux[i] = '0' + val % 10, val /= 10, ++i;

	--i;
	if(i == -1) buff[sz_buff] = '0', ++sz_buff;
	while(i >= 0) {
		buff[sz_buff] = aux[i];
		--i; ++sz_buff;
	}

	buff[sz_buff] = '\n'; ++sz_buff;
}

int check(char *s);
int factor(char *s);
int termen(char *s);

int eval(char *who_name, char *s) {
	int var = -1, i;
	for(i = 0; i < nr; ++i)
		if(cmpchar(who_name, v[i].name)) var = i;
	
	if(!v[var].tip) {
		int len = strlen(s);
		for(i = 0; i < len; ++i) {
			char aux[64];
			int sz = 0;
			memset(aux, 0, sizeof(aux));
			while(i < len && s[i] != '|' && s[i] != '&') {
				aux[sz] = s[i];
				++sz; ++i;
			}

			if(i < len) ++i;
			if(cmpchar(aux, "true") || cmpchar(aux, "false")) continue;

			int j = 0, VR = -1;
			while(aux[j] && aux[j] != '[') ++j;
			aux[j] = 0;
			for(j = 0; j < nr; ++j)
				if(cmpchar(aux, v[j].name)) VR = j, j = nr + 1;

			if(VR == -1) return 0;
			if(v[VR].tip >= 0 && v[VR].tip != v[var].tip) return 0;
			if(v[VR].tip < 0 && -v[VR].tip - 1 != v[var].tip) return 0;
		}
	}

	if(v[var].tip == 1) {
		char* S = malloc(strlen(s) + 5);
		int len = strlen(s);
		for(i = 0; i < len; ++i) {
			char aux[64];
			int sz = 0;
			memset(aux, 0, sizeof(aux));
			if(s[i] == '(') strcat(S, "(");
			if(s[i] == '(')
				continue;
			if((s[i] == '-' || s[i] == '+')) {
				aux[sz] = s[i];
				++sz; ++i;
			}
			while(i < len && s[i] != '+' && s[i] != '-' && s[i] != '*' && s[i] != '/' && s[i] != '%' && s[i] != '(' && s[i] != ')') {
				aux[sz] = s[i];
				++sz; ++i;
			}

			if(!sz) {
				char w[3];
				w[1] = 0; w[0] = s[i];
				strcat(S, w);
				continue;
			}

			if(aux[0] == '"' || aux[0] == '<' || aux[0] == '>' || aux[0] == '|' || aux[0] == '&' || aux[0] == '=' || aux[0] == '%')
				return 0;

			if(number(aux)) {
				strcat(S, aux);
				char w[3];
				w[1] = 0;  w[0] = s[i];
				strcat(S, w);
				continue;
			}

			int j = 0, VR = -1;
			while(aux[j] && aux[j] != '[') ++j;
			aux[j] = 0;
			for(j = 0; j < nr; ++j)
				if(cmpchar(aux, v[j].name)) VR = j, j = nr + 1;

			if(VR == -1) return 0;
			if(v[VR].tip >= 0 && v[VR].tip != v[var].tip) return 0;
			if(v[VR].tip < 0 && -v[VR].tip - 1 != v[var].tip) return 0;

			char buff[64];
			memset(buff, 0, sizeof(buff));
			int Val = max(v[VR].val, -v[VR].val), lung = 0;
			while(Val) buff[lung] = '0' + Val % 10, Val /= 10, ++lung;
			if(v[VR].val < 0) buff[lung] = '-', ++lung;
			for(j = 0; j < lung / 2; ++j) {
				char tmp = buff[j];
				buff[j] = buff[lung - j - 1];
				buff[lung - j - 1] = tmp;
			}

			strcat(S, buff);
			char w[3];
			w[1] = 0;  w[0] = s[i];
			strcat(S, w);
		}

		poz = 0;
		v[var].val = check(S);
	}

	if(v[var].tip == 2) {
		int len = strlen(s);
		for(i = 0; i < len; ++i) {
			char aux[64];
			int sz = 0;
			memset(aux, 0, sizeof(aux));
			if((s[i] == '-' || s[i] == '+')) {
				aux[sz] = s[i];
				++sz; ++i;
			}
			while(i < len && s[i] != '+' && s[i] != '-' && s[i] != '*' && s[i] != '/') {
				aux[sz] = s[i];
				++sz; ++i;
			}


			if(aux[0] == '"' || aux[0] == '<' || aux[0] == '>' || aux[0] == '|' || aux[0] == '&' || aux[0] == '=' || aux[0] == '%')
				return 0;

			if(number_double(aux) || number(aux))
				continue;

			int j = 0, VR = -1;
			while(aux[j] && aux[j] != '[') ++j;
			aux[j] = 0;
			for(j = 0; j < nr; ++j)
				if(cmpchar(aux, v[j].name)) VR = j, j = nr + 1;

			if(VR == -1) return 0;
			if(v[VR].tip >= 0 && v[VR].tip != v[var].tip) return 0;
			if(v[VR].tip < 0 && -v[VR].tip - 1 != v[var].tip) return 0;
		}
	}

	if(v[var].tip == 3) {
		int len = strlen(s);
		for(i = 0; i < len; ++i) {
			char aux[64];
			int sz = 0;
			memset(aux, 0, sizeof(aux));
			while(i < len && s[i] != '+') {
				aux[sz] = s[i];
				++sz; ++i;
			}

			if(strlen(aux) > 1 && aux[0] == '"' && aux[strlen(aux) - 1] == '"')
				continue;

			int j = 0, VR = -1;
			while(aux[j] && aux[j] != '[') ++j;
			aux[j] = 0;
			for(j = 0; j < nr; ++j)
				if(cmpchar(aux, v[j].name)) VR = j, j = nr + 1;

			if(VR == -1) return 0;
			if(v[VR].tip >= 0 && v[VR].tip != v[var].tip) return 0;
			if(v[VR].tip < 0 && -v[VR].tip - 1 != v[var].tip) return 0;
		}
	}

	return 1;
}

int ok_expr(char *s) {
	int len = strlen(s), i;
	for(i = 0; i < len; ++i) {
		char aux[64];
		int sz = 0;
		memset(aux, 0, sizeof(aux));
		if(s[i] == '(')
			continue;
		if((s[i] == '-' || s[i] == '+')) {
			aux[sz] = s[i];
			++sz; ++i;
		}
		while(i < len && s[i] != '+' && s[i] != '-' && s[i] != '*' && s[i] != '/' && s[i] != '%' && s[i] != '(' && s[i] != ')') {
			aux[sz] = s[i];
			++sz; ++i;
		}

		if(aux[0] == '"' || aux[0] == '<' || aux[0] == '>' || aux[0] == '|' || aux[0] == '&' || aux[0] == '=' || aux[0] == '%')
			return 0;

		if(number(aux)) {
			continue;
		}

		int j = 0, VR = -1;
		while(aux[j] && aux[j] != '[') ++j;
		aux[j] = 0;
		for(j = 0; j < nr; ++j)
			if(cmpchar(aux, v[j].name)) VR = j, j = nr + 1;

		if(VR == -1) return 0;
		if(v[VR].tip >= 0 && v[VR].tip != 1) return 0;
		if(v[VR].tip < 0 && -v[VR].tip - 1 != 1) return 0;
	}

	return 1;
}

int get_val_expr(char *s) {
	char* S = malloc(strlen(s) + 5);
	int len = strlen(s), i;
	for(i = 0; i < len; ++i) {
		char aux[64];
		int sz = 0;
		memset(aux, 0, sizeof(aux));
		if(s[i] == '(') strcat(S, "(");
		if(s[i] == '(')
			continue;
		if((s[i] == '-' || s[i] == '+')) {
			aux[sz] = s[i];
			++sz; ++i;
		}
		while(i < len && s[i] != '+' && s[i] != '-' && s[i] != '*' && s[i] != '/' && s[i] != '%' && s[i] != '(' && s[i] != ')') {
			aux[sz] = s[i];
			++sz; ++i;
		}

		if(number(aux)) {
			strcat(S, aux);
			char w[3];
			w[1] = 0;  w[0] = s[i];
			strcat(S, w);
			continue;
		}

		int j = 0, VR = -1;
		while(aux[j] && aux[j] != '[') ++j;
		aux[j] = 0;
		for(j = 0; j < nr; ++j)
			if(cmpchar(aux, v[j].name)) VR = j, j = nr + 1;

		char buff[64];
		memset(buff, 0, sizeof(buff));
		int Val = max(v[VR].val, -v[VR].val), lung = 0;
		while(Val) buff[lung] = '0' + Val % 10, Val /= 10, ++lung;
		if(v[VR].val < 0) buff[lung] = '-', ++lung;

		for(j = 0; j < lung / 2; ++j) {
			char tmp = buff[j];
			buff[j] = buff[lung - j - 1];
			buff[lung - j - 1] = tmp;
		}
		strcat(S, buff);
		char w[3];
		w[1] = 0;  w[0] = s[i];
		strcat(S, w);
	}

	poz = 0;
	return check(S);
}

int check(char *s) {
	int aux = termen(s);
	while(s[poz] == '+' || s[poz] == '-') 
		if(s[poz] == '+') ++poz, aux += termen(s);
		else ++poz, aux -= termen(s);
	return aux;
}

int factor(char *s) {
	int aux = 0;
	if(s[poz] == '(') ++poz, aux = check(s), ++poz;
	else {
		while(s[poz] >= '0' && s[poz] <= '9') {
			aux *= 10;
			aux += s[poz] - '0';
			++poz;
		}
	}
	return aux;
}

int termen(char *s) {
	int aux = factor(s);
	while(s[poz] == '*' || s[poz] == '/' || s[poz] == '%')
		if(s[poz] == '*') ++poz, aux *= factor(s);
		else if(s[poz] == '/') ++poz, aux /= factor(s);
			 else ++poz, aux %= factor(s);
	return aux;
}

int max(int a, int b) {
	if(a < b) return b;
	return a;
}

int min(int a, int b) {
	if(a > b) return b;
	return a;
}

int cmmdc(int a, int b) {
	a = max(a, -a);
	b = max(b, -b);
	while(a && b) (a > b ? (a %= b) : (b %= a));
	return a + b;
}

int cmmmc(int a, int b) {
	return (a * b) / cmmdc(a, b);
}

int abs(int a) {
	return max(a, -a);
}

int isPrime(int a) {
	if(a == 2) return 1;
	if(a % 2 == 0) return 0;
	int i;
	for(i = 3; i * i <= a; i += 2)
		if(a % i == 0) return 0;
	return 1;
}

int cmpchar(char *a, char *b) {
	int i = 0;
	while(a[i] && b[i])
		if(a[i] != b[i])
			return 0;
		else ++i;

	if(a[i] || b[i]) return 0;
	return 1;
}

int checkVar(char *name, int op) {
	if(!op) {
		int i;
		for(i = 0; i < nr; ++i)
			if(cmpchar(name, v[i].name)) return 0;
		return 1;
	}

	int i;
	for(i = 0; i < nr; ++i)
		if(cmpchar(name, v[i].name) && v[i].tip > -1) return 1;

	return 0;
}

int addVar(char *name, char *type, char *val) {
	if(!checkVar(name, 0)) return 0;
	if(cmpchar(type, "bit")) v[nr].tip = -1;
	if(cmpchar(type, "googol")) v[nr].tip = -2;
	if(cmpchar(type, "love")) v[nr].tip = -3;
	if(cmpchar(type, "book")) v[nr].tip = -4;

	memcpy(v[nr].name, name, strlen(name));

	if(v[nr].tip == -4 && (val[0] != '"' || val[strlen(val) - 1] != '"')) return -1;
	if(v[nr].tip == -3) {
		int gasit_punct = 0, i = 0;
		while(val[i] && !gasit_punct)
			if(val[i] == '.') gasit_punct = 1;
			else ++i;
		for(i = 1; val[i]; ++i)
			if(val[i] >= '0' && val[i] <= '9') continue;
			else if(val[i] == '.') continue;
				 else gasit_punct = 0;
		if(val[0] < '0' || val[0] > '9') if(val[0] != '-' && val[0] != '+') gasit_punct = 0;
		if(!gasit_punct) return -1;
	}

	if(v[nr].tip == -2) {
		if(val[0] < '0' || val[0] > '9') if(val[0] != '-' && val[0] != '+') return -1;
		int i;
		for(i = 1; val[i]; ++i)
			if(val[i] < '0' || val[i] > '9') return -1;

		if(val[0] == '+' || val[0] == '-') i = 1;
		else i = 0;
		for(; val[i]; ++i) v[nr].val *= 10, v[nr].val += val[i] - '0';
	}

	if(v[nr].tip == -1) {
		if(!cmpchar(val, "true") && !cmpchar(val, "false")) return -1;
	}

	++nr;

	return 1;
}

int addVar2(char *name, int tip) {
	if(!checkVar(name, 0)) return 0;
	v[nr].tip = tip;

	memcpy(v[nr].name, name, strlen(name));
	++nr;

	return 1;
}

int get_tip(char *tip) {
	int i = 0;
	while(tip[i] && tip[i] != '[') ++i;

	tip[i] = 0;

	if(cmpchar(tip, "bit")) return 0;
	if(cmpchar(tip, "googol")) return 1;
	if(cmpchar(tip, "love")) return 2;
	if(cmpchar(tip, "book")) return 3;

	return -1;
}

int get_val(char *name) {
	int i;
	for(i = 0; i < nr; ++i)
		if(cmpchar(name, v[i].name))
			return v[i].val;
	return -1;
}

int Check_new_vars(int tip) {
	int i, j;
	for(i = 0; i < qwen; ++i) {
		if(!checkVar(qwe[i], 0)) return 0;
		memcpy(v[nr].name, qwe[i], strlen(qwe[i]));
		v[nr].tip = tip; ++nr;
	}
	return 1;
}

int number(char* s) {
	if(s[0] < '0' || s[0] > '9') {
		if(s[0] != '+' && s[0] != '-') 
			return 0;
	}

	int i;
	for(i = 1; s[i]; ++i)
		if(!(s[i] >= '0' && s[i] <= '9'))
			return 0;
	return 1;
}

int number_double(char* s) {
	if(number(s)) return 1;

	if(s[0] < '0' || s[0] > '9') {
		if(s[0] != '+' && s[0] != '-' && s[0] != '.')
			return 0;
	}

	int i, cnt = 0;
	for(i = 1; s[i]; ++i) {
		if(s[i] == '.') ++cnt;
		else if(s[i] < '0' || s[i] > '9')
				return 0;
	}

	if(cnt > 1) return 0;
	return 1;
}