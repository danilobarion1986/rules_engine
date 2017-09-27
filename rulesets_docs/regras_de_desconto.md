#Regras de Desconto

Este conjunto de regras define quem terá direito ao desconto especial na linha de produtos masculinos.

##Maior de 18 anos

O usuário deve ser maior de 18 anos.

This rule is applied to class _User_.

Rule assertion:

```
-> (x) { x.age > 18 }
```

##Masculino

O usuário deve ser do sexo masculino.

This rule is applied to class _User_.

Rule assertion:

```
-> (x) { x.gender == :masculino }
```

##Usuário Premium

O usuário deve ser premium.

This rule is applied to class _User_.

Rule assertion:

```
->(x) { x.premium }
```

