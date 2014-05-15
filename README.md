# Pr�ctica 9 - PDL - Transformaciones en Los �rboles del Analizador

## Autores

* Cristo Gonz�lez Rodr�guez - alu0100694987
* Sawan J. Kapai Harpalani - alu0100694765

## Objetivo de la Pr�ctica

El objetivo de la pr�ctica reside en la realizaci�n del an�lisis de �mbito en la implementaci�n de un analizador de PL0 ampliado, empleando Jison.
Cada procedimiento tiene asociado una tabla de s�mbolos, que incluye todas las constantes, variables, y otros procedimientos del mismo (as� como una de �mbito global).
As� mismo, se deben guardar en la base de datos los programas, con el identificador del usuario que lo ha almacenado; proporcionando la posibilidad a los usuarios de visualizar aquellos programas que han guardado.

Se desea crear una forma capaz de recorrer el �rbol generado por el parser para realizar un plegado de constantes.

## Recursos utilizados

* Jison: http://zaach.github.io/jison/ - Generaci�n del analizador ampliado de PL0
* OAuth: http://oauth.net/ - Protocolo abierto que permite la autentificaci�n segura
* Heroku: https://www.heroku.com/ - Plataforma de aplicaciones en la nube
* Heroku Postgres: https://devcenter.heroku.com/articles/heroku-postgresql - Servicio de base de datos SQL proporcionado por Heroku
* DataMapper: http://datamapper.org/ - ORM escrito en Ruby

## Realizaci�n de la Pr�ctica

* README.md - Cristo [OK]
* An�lisis de �mbito - Cristo [OK]
* Base de Datos - Sawan [OK]
* Pruebas - Cristo | Sawan [OK]

## Despliegue

* Heroku: http://analizador-p9pdl.herokuapp.com/
* Pruebas: http://analizador-p9pdl.herokuapp.com/tests