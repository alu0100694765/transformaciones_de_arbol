# Práctica 9 - PDL - Transformaciones en Los Árboles del Analizador

## Autores

* Cristo González Rodríguez - alu0100694987
* Sawan J. Kapai Harpalani - alu0100694765

## Objetivo de la Práctica

El objetivo de la práctica reside en la realización del análisis de ámbito en la implementación de un analizador de PL0 ampliado, empleando Jison.
Cada procedimiento tiene asociado una tabla de símbolos, que incluye todas las constantes, variables, y otros procedimientos del mismo (así como una de ámbito global).
Así mismo, se deben guardar en la base de datos los programas, con el identificador del usuario que lo ha almacenado; proporcionando la posibilidad a los usuarios de visualizar aquellos programas que han guardado.

Se desea crear una forma capaz de recorrer el árbol generado por el parser para realizar un plegado de constantes.

## Recursos utilizados

* Jison: http://zaach.github.io/jison/ - Generación del analizador ampliado de PL0
* OAuth: http://oauth.net/ - Protocolo abierto que permite la autentificación segura
* Heroku: https://www.heroku.com/ - Plataforma de aplicaciones en la nube
* Heroku Postgres: https://devcenter.heroku.com/articles/heroku-postgresql - Servicio de base de datos SQL proporcionado por Heroku
* DataMapper: http://datamapper.org/ - ORM escrito en Ruby

## Realización de la Práctica

* README.md - Cristo [OK]
* Análisis de Ámbito - Cristo [OK]
* Base de Datos - Sawan [OK]
* Pruebas - Cristo | Sawan [OK]

## Despliegue

* Heroku: http://analizador-p9pdl.herokuapp.com/
* Pruebas: http://analizador-p9pdl.herokuapp.com/tests