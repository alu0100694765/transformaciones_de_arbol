# Práctica 7 - PDL - Analizador de PL0 ampliado utilizando Jison

## Autores

* Cristo González Rodríguez - alu0100694987
* Sawan J. Kapai Harpalani - alu0100694765

## Objetivo de la Práctica

El objetivo de la práctica reside en la utilización de Jison, un generador automático de analizadores a partir de una gramática, para la creación de un analizador de PL0 ampliado.
Se debe especificar la gramática reconocida, en el correspondiente apartado, asi como permitir guardar un máximo prefijado de programas, suprimiendo uno al azar en caso de superar el límite.
Permitiendo únicamente almacenar ficheros a los usuarios autentificados (para lo que se debe extender la autentificación OAuth), con Google y otra plataforma que proporcione dicho servicio.
Por último se realizaran una serie de pruebas que permitirán comprobar el correcto funcionamiento de todas las posibles sentencias del lenguaje que comprende el analizador; asi como una serie de situaciones de error.

## Recursos utilizados

* Jison: http://zaach.github.io/jison/ - Generación del analizador ampliado de PL0
* OAuth: http://oauth.net/ - Protocolo abierto que permite la autentificación segura
* Heroku: https://www.heroku.com/ - Plataforma de aplicaciones en la nube
* Heroku Postgres: https://devcenter.heroku.com/articles/heroku-postgresql - Servicio de base de datos SQL proporcionado por Heroku
* DataMapper: http://datamapper.org/ - ORM escrito en Ruby

## Realización de la Práctica

* README.md - Cristo [OK]
* Página principal y vistas - Cristo | Sawan [OK]
* Documentación de la gramática - Cristo [OK]
* Implementación Analizador - Cristo [OK]
* Code Mirror -Cristo [OK]
* Base de Datos - Cristo | Sawan [OK]
* Autentificación - Sawan [OK]
* Pruebas - Sawan [OK]
* Despliegue Heroku - Sawan [OK]
* Estilo - Cristo | Sawan [OK]

## Despliegue

* Heroku: http://analizador-p7pdl.herokuapp.com/
* Pruebas: http://analizador-p7pdl.herokuapp.com/tests