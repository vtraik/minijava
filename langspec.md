# MiniJava Language Specification

## 1. Overview

MiniJava is a simplified, fully object-oriented language based on Java. The language does not allow global functions; programs consist exclusively of classes containing fields and methods.

The primitive types are:

* `int`
* `boolean`
* `int[]`

Classes may contain fields of primitive types or other class types, as well as methods whose parameters and return types may be primitive or class types.

---

## 2. Classes

### Supported Features

MiniJava supports:

* Classes
* Fields
* Methods
* Single inheritance

The `new` operator invokes an implicit default constructor.

---

## 3. Inheritance

MiniJava supports **single inheritance**.

```java
class A { }
class B extends A { }
```

A superclass must always be declared before any subclass that extends it.

Classes may reference other classes that appear later in the source file.

```java
class A {
    B b;
}

class B { }
```

is valid.

Subclass instances may be used wherever a superclass is expected.

```java
A a = new B();
```

Likewise, if a method expects an object of type `A`, an instance of `B` may be passed provided `B` extends `A`.

---

## 4. Fields

Fields may have primitive or class types.

A field name cannot appear more than once within the same class.

A subclass may declare a field with the same name as one in its superclass. These are treated as **distinct fields**.

```java
class A {
    int x;
}

class B extends A {
    int x;
}
```

All fields are `protected`.

A class method cannot directly access the fields of another class, except inherited fields.

---

## 5. Methods

Every method:

* has a return type,
* is public,
* is dynamically dispatched (virtual).

There are no `void` methods.

Methods may be invoked using `this`.

```java
this.foo();
```

or through object references.

```java
obj.foo();
```

---

### 5.1 Method Overriding

A subclass may override a method defined in one of its ancestors.

An override is valid only when:

* the method name is identical,
* parameter types are identical and appear in the same order,
* the return type is identical.

Otherwise, the declaration is treated as a different method and must satisfy the overloading rules.

---

### 5.2 Method Overloading

MiniJava supports **restricted overloading**.

Methods with the same name may coexist if they are unambiguously distinguishable.

The following rules apply:

* Methods with different numbers of parameters are always allowed.
* Methods with the same number of parameters are allowed only if there exists at least one parameter position where the corresponding parameter types are unrelated through inheritance (neither is a subtype nor a supertype of the other).
* If every corresponding parameter type is related through inheritance, the declaration is illegal.

The only exception is when:

* the methods belong to different classes in the same inheritance hierarchy,
* every parameter type is identical,
* the return type is identical.

In this case, the declaration is considered an override rather than an overload.

Unlike Java, overloaded methods may have different return types.

---

## 6. Variables and Scope

Local variables:

* are declared only at the beginning of a method,
* cannot be declared more than once within the same method.

A local variable shadows a field with the same name.

---

## 7. Expressions

MiniJava provides a deliberately small expression language.

Supported features include:

* object creation (`new`)
* method calls
* array indexing (`[]`)
* array assignment
* `length`
* logical AND (`&&`)
* logical NOT (`!`)
* less-than comparison (`<`)

The only comparison operator is `<`.

Method calls may appear as arguments to other method calls.

---

## 8. Statements

MiniJava supports:

* assignments,
* `if ... else`,
* `while`.

Every `if` statement must be followed by an `else` branch.

---

## 9. Arrays

The only array type is `int[]`.

Supported operations include:

* indexing (`a[i]`)
* assignment (`a[i] = x`)
* length (`a.length`)

---

## 10. Program Structure

A MiniJava program begins with a special class containing the `main` method.

This class:

* contains no fields,
* has a predefined `main` signature,
* receives arguments that are ignored.

All remaining classes follow this special class.

