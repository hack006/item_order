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
    Dvojice řetězců vždy reprezentuje řetězec k zapamatování (_defaultně 5s_)
    1. 

  
#### Reference
Experiment byl implementován na základě informací z již zpracovaného experimentu pro psychologický experimentální software _PEBL_.
* [Odkaz na popis implementaci experimentu](http://peblblog.blogspot.cz/2010/06/item-order-test.html)

### Technické řešení

### TODO

* implementace poloautomatického generování dat
* dialog pro konfiguraci vnitřních parametrů
	* čas pamatování
	* čas schování stimulu
	* procentuelní zastoupení typů jednotlivých pokusů (pozice, záměna, shodné)
