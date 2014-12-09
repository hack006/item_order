# Item order psychological experiment

## English
This is implementation of **item order** psychological experiment written for great _open-source_ toolbox PSYCHEEg which is based on _Matlab_.

### PSYCHEEg
Matlab toolbox for psychological experiments supporting EEG measurement. Developed on CTU in Prague. More info: [PSYCHEEg homepage](http://bio.felk.cvut.cz/psychee/)

## Czech

Následující část popisuje řešení psychologického experimentu **item order text** v Matlabu. Úloha byla zpracována v rámci předmětu a6m33ksy (Kognitivní psychologie) na ČVUT v Praze.

### Popis experimentu
Experiment si klade za cíl zjistit zpracovávání a uchovávání **pořadí** a **změny prvku** v krátkodobé paměti.

#### Průběh experimentu
1. V první fázi je vygenerována testovací sada, která se skládá z dvojice řetězců dlouhých 7 znaků. 
  1. Aktuálně jsou podporovány 2 možnosti generování dat.

    * **Automatické generování** - data jsou vygenerována zcela náhodně a to na základě (aktuálně) napevno nastavených defaultních hodnot uvnitř _třídy_ experimentu.
      * _character_swap_percentage_ - procentuální zastoupení pokusu experimentu, kde dochází k prohození pořadí 2 sousedích znaků
      * _character_change_percentage_ - procentuální zastoupení pokusu experimentu, kde dochází k záměně znaku
      * _character_position_change_percentage_ - definuje procentuální rozložení změn znaků na jednotlivých pozicích řetězce
    
      ![Dialog pro automatické zadávání dat experimentu](/docs/img/random_generator_results.png)
    * **Manuální generování** - je zobrazen přehledný dialog s tabulkou, do které se zadají veškeré potřebné údaje. Je implementováno hlídání validity vstupního formátu dat.
  
      ![Dialog pro manuální zadávání dat experimentu](/docs/img/manual_trials_generator.png)
  
  2. Možné typy pokusů.
    Dvojice řetězců vždy reprezentuje řetězec k zapamatování (_defaultně 5s_) a řetězec k porovnání (_zobrazen po prodlevě 2s_), u kterého participant experimentu rozhoduje, zda je shodný s tím k zapamatování.
    1. **Řetězce jsou shodné** - např. str1="BCDFGHJ", str2="BCDFGHJ"
    2. **Záměna znaku** - např. str1="BCDFGHJ", str2="BCYFGHJ" (_záměna 3. znaku za Y_)
    3. **Změna pořadí** - např. str1="BCDFGHJ", str2="BDCFGHJ" (_prohození znaků na 2. a 3. pozici_)
2. Následně je spuštěn experiment, kde jsou participantům postupně zobrazovány všechny pokusy a on rozhoduje (pomocí 2 kláves), zda se řetězce shodují. Vše probíhá v těchto fázích.
  1. Čekání na zahájení pokusu stiskem klávesy
  2. Zobrazení řetězce k zapamatování po dobu 5s (_výchozí hodnota_)
  3. Skrytí textu po dobu 2s (_výchozí hodnota_)
  4. Zobrazení řetězce k rozhodnutí, zda se shoduje s předchozím, či nikoliv.
3. Jsou uloženy výsledky experimentu a je zobrazena úspěšnost včetně průměrného času pokusu. _Toto je již výhradně v režii PSYCHEEg toolboxu_.
4. Zbývá vyhodnotit naměřená data ... :)

  
#### Reference
Experiment byl implementován na základě informací z již zpracovaného experimentu pro psychologický experimentální software _PEBL_.
* [Odkaz na popis implementaci experimentu](http://peblblog.blogspot.cz/2010/06/item-order-test.html)

### Technické řešení

### TODO
Následující souhrn věcí je možné doimplementovat nebo vylepšit v rámci budoucího rozšiřování experimentu.

* Implementace poloautomatického generování dat
* Dialog pro konfiguraci vnitřních parametrů
	* čas pamatování
	* čas schování stimulu
	* procentuelní zastoupení typů jednotlivých pokusů (pozice, záměna, shodné)
