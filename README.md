# minijava - semantic analysis

## compilation && run
``` bash
make
```

``` bash
java -cp bin [MainClassName] [file1] [file2] ... [fileN]
```

---

## structure

``` bash
├── grammar
│   └── minijava.jj
├── javacc5.jar
├── jtb132di.jar
├── Makefile
├── README.md
├── src
│   ├── Main.java
│   ├── mj_visitors
│   │   ├── DeclVisitor.java
│   │   └── RefVisitor.java
│   └── symboltable
│       ├── ClassInfo.java
│       ├── MethodInfo.java
│       ├── Symbol.java
│       └── SymbolTable.java
```

---

## symboltable
- <ins>SymbolTable</ins>:  
Το symbol table ακολουθεί τη λογική του chained implementation. Οι κλάσεις είναι ένα **LinkedHashMap** (για να διατηρείται η σειρά εισαγωγής τους).
Υπάρχει επίσης ένα LinkedHashMap που διατηρεί τη σειρά εισαγωγής όλων των μεθόδων και χρησιμοποιείται στον RefVisitor για να αποφευχθεί η χρονοβόρα αναζήτηση της μεθόδου στο MethodDecleration (δηλαδή πηγαίνοντας πάλι στο FormalParameter list, το οποίο θα επιστρέψει τις παραμέτρους που θα φτίαξουν το όνομα: foo_params και τελικά θα αναζητηθεί στο methodsSignatures). Αντιθέτως κρατείται απλώς η σειρά εισαγωγής με έναν counter (0...n) στον DeclVisitor και χρησιμοποιείται στον RefVisitor για να πάρει τον τύπο επιστροφής της $i$ συνάρτησης στη σειρά και να ελεγχθεί με τον τύπο του return expression.

- <ins>ClassInfo</ins>:  
Κάθε κλάση έχει δύο δομές για τις μεθόδους, ένα **LinkedHashMap** που κάνει map (foo_int_boolean -> MethodInfo) και ένα (foo -> List<MethodInfo>).
Το πρώτο χρησιμοποιείται κυρίως για override check και το δεύτερο για overload. Επίσης υπάρχει ένα άλλο LinkedHashMap για τα πεδία. Κρατείται
η υπερκλάση, το όνομα της κλάσης και τα offset για τις μεθόδους και τα πεδία.  

- <ins>MethodInfo</ins>:  
Κρατούνται οι παράμετροι σε **ArrayList** και οι τοπικές μεταβλητές σε **HashMap**. Επίσης υπάρχει ο τύπος επιστροφής μαζί με το όνομα σε 1 Symbol, το όνομα μαζί με τις παραμέτρους (foo_int_boolean), αν είναι μία override μέθοδος ή όχι και το offset της μεθόδου μέσα στη κλάση που βρίσκεται.

- <ins>Symbol</ins>:  
Ορίζεται από το όνομα, τύπο και το offset του. Η ισότητα δύο συμβόλων γίνεται με βάση το όνομα.

---

## DeclVisitor
Στο πρώτο πέρασμα γεμίζει το symbol table με τις δηλώσεις κλάσεων, μεθόδων, πεδίων, τοπικών μεταβλητών. Κόβονται μόνο ακατάλληλα overrides
και τύποι που δεν έχουν οριστεί. Τα overrides ελέγχονται στη μέθοδο **MethodDecleration** όπου αν βρεθεί σε κάποια υπερκλάση η ίδια υπογραφή μεθόδου
ελέγχεται αν ο τύπος επιστροφής είναι ο ίδιος ή όχι για να καθοριστεί έγκυρο override ή όχι. Ίδιες υπογραφές μέσα στην ίδια μέθοδο κόβονται από την
`addMethod`. Το ίδιο ισχύει για όλα τα διπλότυπα στο ίδιο scope, οι αντίστοιχες add μέθοδοι τα απορρίπτουν. 
Το **scope** που βρίσκομαι κάθε στιγμή είναι το δεύτερο όρισμα της κάθε μεθόδου `(argu = class|method_params or class|null)`. Οι τύποι που δεν έχουν ορίστει κόβονται με το **set** που κρατάω κάθε στιγμή τους τύπους για τους οποίους δεν έχω δει ορισμό. Δηλαδή κάνω add τύπους σε MethodDecleration και VarDecleration και remove σε ClassDecleration και ClassExtendsDecleration. Αν όταν τελείωσει το πέρασμα το set μου είναι μη κενό τότε υπάρχουν τύποι που δεν έχουν οριστεί.

Μετά το πρώτο πέρασμα ελέγχω τα **overloads** (`checkOverloadingViolations`) και υπολογίζω τα offsets. Διατρέχω το symbol table και για κάθε ομάδα μεθόδων
με το ίδιο όνομα (πχ foo) ελέγχω το overloading μέσα στη κλάση (`checkOverloading`) αλλά και κλάσης με υπερκλάσεις (`checkOverloadingSuperClass`).

- <ins>checkOverloading</ins>:  
Μέσα στην ίδια κλάση ο έλεγχος είναι απλός καθώς έχω τη λίστα με τις μεθόδους με το ίδιο όνομα (πχ foo). Για όλα τα ζευγάρια μεθόδων με ίδιο όνομα
ελέγχω αν όλοι οι τύποι των παραμέτρων τους έχουν subtype ή supertype σχέση. Αν ναι τότε δεν είναι σωστό overloading, αν όχι τότε είναι.

- <ins>checkOverloadingSuperClass</ins>:  
Εδώ ο έλεγχος γίνεται για όλες τις υπερκλάσεις της κλάσης που βρίσκεται η μέθοδος. Κάθε μέθοδος με το συγκεκριμένο όνομα (πχ foo) της κλάσης
που δεν είναι override ελέγχεται με κάθε μέθοδο της υπερκλάσης με το ίδιο όνομα (foo).

---

## RefVisitor
- <ins>findVarType</ins>:  
Χρησιμοποιείται για να βρεθεί ο τύπος μιας μεταβλητής. Καλείται στον ορισμό της **Identifier** μεθόδου. Αυτό δημιουργεί πρόβλημα καθώς
δεν θέλω για όλους τους identifiers τον τύπο τους, σε κάποιους θέλω το όνομα τους μόνο. Αυτό λύνεται είτε επιλέγοντας ρητά το token
μέσω του **n.fk.tokenImage** (k >= 0) είτε με τον ορισμό της **Type μεθόδου** (η οποία είναι αποτέλεσμα μόνο δηλώσεων, οπού εκεί θέλω το όνομα),
η οποία βλέπει αν κάνει resolve ο κανόνας σε identifier ώστε να επιστρέψει το token ή όχι, οπότε να έχει το default χειρισμό.

- <ins>findMethodRetType</ins>:  
Χρησιμοποιείται για να βρεθεί ο τύπος επιστροφής μιας συμβατής μεθόδου όταν καλείται μια μέθοδος. 

- <ins>getClassCompMethod</ins>:  
Ψάχνει μια συμβατή μέθοδο στη κλάση.

- <ins>findNodeToken</ins>:  
Κατεβαίνει την ιεραρχία μέχρι να βρει instance από NodeToken ώστε να παρθούν οι συντεταγμένες του error (χρησιμοποιούνται στα error messages).
