#Regras de Desconto

Este conjunto de regras define quem terá direito ao desconto especial na linha de produtos masculinos.

##Maior de 18 anos

O usuário deve ser maior de 18 anos.

This rule is applied to class _User_.

Rule assertion:

```
-> (x) { x.age > 18 }
```

Rule created on:
- File: main.rb
- Line: 25


##Masculino

O usuário deve ser do sexo masculino.

This rule is applied to class _User_.

Rule assertion:

```

```

Rule created on:
- File: main.rb
- Line: 28


##Usuário Premium

O usuário deve ser premium.

This rule is applied to class _User_.

Rule assertion:

```
->(x) { x.premium }
```

Rule created on:
- File: main.rb
- Line: 35


