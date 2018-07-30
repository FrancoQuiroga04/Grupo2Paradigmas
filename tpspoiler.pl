%PUNTO 1:
miraSerie(juan, himym).
miraSerie(juan, got).
miraSerie(juan, futurama).
miraSerie(nico, starWars).
miraSerie(nico, got).
miraSerie(maiu, starWars).
miraSerie(maiu, onePiece).
miraSerie(maiu, got).
miraSerie(gaston, got).
miraSerie(pedro, got).
%Alf no ve ninguna serie. Por principio de universo cerrado, asumimos que es falso y directamente no modelamos el hecho de que no mire nada.
%Tampoco decimos que nadie ve Mad Men por la misma razón que no formulamos el hecho de que Alf no mira ninguna serie.
 quienPlaneaVerQue(juan, hoc).
quienPlaneaVerQue(aye, got).
quienPlaneaVerQue(gaston, himym).
 %cuántosEpisodiosTieneTalTemporada (Serie, Temporada, Episodio)
cuantosEpisodiosTieneTalTemporada(got, 10, 2).
cuantosEpisodiosTieneTalTemporada(got, 12, 3).
cuantosEpisodiosTieneTalTemporada(himym, 23, 1).
cuantosEpisodiosTieneTalTemporada(drHouse, 16, 8).
%No sabemos cuántos episodios tiene la segunda temporada de Mad Men, por lo cual tampoco sabemos si contiene alguno, y por principio de universo cerrado no nos interesa consultar si es que los tiene y asumimos que es falso, dejándo la proposición sin modelar.
 %PUNTO 2:
%paso(Serie, Temporada, Episodio, Lo que paso)
 paso(futurama, 2, 3, muerte(seymourDiera)).
paso(starWars, 10, 9, muerte(emperor)).
paso(starWars, 1, 2, relacion(parentesco, anakin, rey)).
paso(starWars, 3, 2, relacion(parentesco, vader, luke)).
paso(himym, 1, 1, relacion(amorosa, ted, robin)).
paso(himym, 4, 3, relacion(amorosa, swarley, robin)).
paso(got, 4, 5, relacion(amistad, tyrion, dragon)).
paso(got, 3, 2, plotTwist([suenio,sinPiernas])).
paso(got, 3, 12, plotTwist([fuego, boda])).
paso(superCampeones, 9, 9, plotTwist([suenio,coma,sinPiernas])).
paso(doctorHouse, 8, 7, plotTwist([coma,pastillas])).


 %leDijo/4
leDijo(gaston, maiu, got, relacion(amistad, tyrion, dragon)).
leDijo(nico, maiu, starWars, relacion(parentesco, vader, luke)).
leDijo(nico, juan, got, muerte(tyrion)).
leDijo(aye, juan, got, relacion(amistad, tyrion, john)).
leDijo(aye, maiu, got, relacion(amistad, tyrion, john)).
leDijo(aye, gaston, got, relacion(amistad, tyrion, dragon)).
leDijo(nico, juan, got, muerte(seymourDiera)).
leDijo(pedro, aye, got, relacion(amistad, tyrion, dragon)).
leDijo(pedro, nico, got, relacion(parentesco, tyrion, dragon)).
 amigo(nico, maiu).
amigo(maiu, gaston).
amigo(maiu, juan).
amigo(juan, aye).
 %PUNTO 3:
 %esSpoiler (Serie, Lo que pasó en esa serie).
 %Ya saben todo lo que pasó realmente, no vuelvan a escribirlo para saber si algo es spoiler.
%Replanteen esSpoiler sin repetir ningún suceso.
 esSpoiler(Serie, Suceso):-
paso(Serie, _, _, Suceso).
 :- begin_tests(spoilers).
 test(muerte_de_emperor_es_spoiler_para_star_wars, nondet) :-
esSpoiler(starWars, muerte(emperor)).
test(muerte_de_pedro_no_es_spoiler_para_star_wars, nondet):-
not(esSpoiler(starWars, muerte(pedro))).
test(parentesco_entre_anakin_y_el_rey_es_spoiler_para_star_wars, nondet):-
esSpoiler(starWars, relacion(parentesco, anakin, rey)).
test(parentesco_entre_anakin_y_Lavezzi_no_es_spoiler_para_star_wars, nondet):-
not(esSpoiler(starWars, relacion(parentesco, anakin, lavezzi))).
 :- end_tests(spoilers).
 %PUNTO 4:
 leSpoileo(Nombre1, Nombre2, Serie):-
conoceSerie(Nombre2, Serie),
esSpoiler(Serie, Spoiler),
leDijo(Nombre1, Nombre2, Serie, Spoiler).

conoceSerie(Nombre, Serie):- quienPlaneaVerQue(Nombre, Serie).
conoceSerie(Nombre, Serie):- miraSerie(Nombre, Serie).

 :- begin_tests(spoilear).
 test(alguien_le_spoileo_a_alguien_mas,[true(Serie == got), nondet]) :-
leSpoileo(gaston, maiu, Serie).
test(alguien_le_spoileo_a_alguien_mas,[true(Serie == starWars), nondet]) :-
leSpoileo(nico, maiu, Serie).
 :- end_tests(spoilear).

 %PUNTO 5:

 televidenteResponsable(Televidente):- persona(Televidente), not(leSpoileo(Televidente, _, _)).
 persona(Persona) :- conoceSerie(Persona, _).
 :- begin_tests(responsables).
 test(alguien_es_televidente_responsable, set(Televidente == [juan, aye, maiu])) :-
televidenteResponsable(Televidente).
 :- end_tests(responsables).

esPopular(got).
esPopular(hoc).
esPopular(himym).

 %PUNTO 6:

vieneZafando(Alguien, Serie):-
cuantosEpisodiosTieneTalTemporada(Serie, _, _),
conoceSerie(Alguien, Serie),
esPopularOPasaronCosasFuertes(Serie),
not(leSpoileo(_, Alguien, Serie)).

esPopularOPasaronCosasFuertes(Serie):- esPopular(Serie).
esPopularOPasaronCosasFuertes(Serie):-
paso(Serie, _, _, unSuceso),
hechoFuerte(unSuceso).

 :- begin_tests(zafando).
 test(viene_zafando_de,
set(Serie == [futurama,got,himym,hoc])) :-
vieneZafando(juan, Serie).
test(viene_zafando_de, set(PersonaZafante == [nico])):-
vieneZafando(PersonaZafante, starWars).
test(viene_zafando_de, set(Serie == [onePiece])):-
vieneZafando(maiu, Serie).
 :- end_tests(zafando).

 %%%%PARTE 2

%PUNTO 1

malaGente(Persona):-
conoceONoConoce(Persona, Serie),
forall(leDijo(Persona, Personas, Serie, _), leSpoileo(Persona, Personas, Serie)).

conoceONoConoce(Persona, Serie):- conoceSerie(Persona, Serie).
conoceONoConoce(Persona, Serie):- not(conoceSerie(Persona, Serie)).


 %PUNTO 2

 hechoFuerte(relacion(amorosa, _, _)).
 hechoFuerte(muerte(_)).
 hechoFuerte(relacion(parentesco, _, _)).

hechoFuerte(plotTwist(ListaDePalabras)):-
paso(Serie, _, _, plotTwist(ListaDePalabras)),
paso(OtraSerie, _, _, plotTwist(OtraListaDePalabras)),
Serie \= OtraSerie,
member(ListaDePalabras, OtraListaDePalabras).

esFuerte(Serie, Suceso):-
conoceSerie(_, Serie),
paso(Serie, _, _, Suceso),
hechoFuerte(Suceso).


 %??
 %PUNTO 3
 cuantosMiran(Serie):-
 esPopular(hoc).
esPopular(Serie):- popularidad(starWars,PuntosDePopularidad),
popularidad(Serie,PuntosDePopularidad2),
PuntosDePopularidad >= PuntosDePopularidad2.
 popularidad(Serie, PuntosDePopularidad):- cuantosMiranLaSerie(Serie, Cantidad),
cuantosHablanDeLaSerie(Serie, Cantidad2),
PuntosDePopularidad is Cantidad * Cantidad2.
 cuantosMiranLaSerie(Serie, Cantidad):-findall(Alguien, (miraSerie(Alguien, Serie)), MiranSerie),
length(MiranSerie, Cantidad).
 cuantosHablanDeLaSerie(Serie, CantidadTotal):-
findall(Alguien, (leDijo(Alguien, _, Serie, _)), HablanDeLaSerie),
findall(OtraPersona, (leDijo(_, OtraPersona, Serie, _)), LeCuentanDeLaSerie),
length(HablanDeLaSerie, Cantidad),
length(LeCuentanDeLaSerie, Cantidad2),
CantidadTotal is Cantidad + Cantidad2.

 %PUNTO 4

fullSpoil(Persona1, Persona2):- leSpoileo(Persona1, Persona2, _).
fullSpoil(Persona1, Persona2):-
findall(Alguien, amigo(Persona2, Alguien), listadeAmigos),
forall(fullSpoil(Persona1, listadeAmigos), listadeAmigos).
