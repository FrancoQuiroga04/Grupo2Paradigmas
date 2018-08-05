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

%PUNTO 3:

ocurrioSuceso(Serie, Suceso):-
paso(Serie, _, _, Suceso).

esSpoiler(Serie, muerte(Personaje)):-
ocurrioSuceso(Serie, muerte(Personaje)).

esSpoiler(Serie, relacion(TipoDeRelacion, Personaje1, Personaje2)):-
ocurrioSuceso(Serie, relacion(TipoDeRelacion, Personaje1, Personaje2)).

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

 televidenteResponsable(Televidente):-
  persona(Televidente),
  not(leSpoileo(Televidente, _, _)).

 persona(Persona) :-
 conoceSerie(Persona, _).

:- begin_tests(responsables).

test(juan_es_televidente_responsable, set(Televidente == [juan, maiu])) :-
televidenteResponsable(Televidente).

test(nico_no_es_televidente_responsable) :-
not(televidenteResponsable(nico)).

test(gaston_no_es_televidente_responsable) :-
not(televidenteResponsable(gaston)).

:- end_tests(responsables).

 %PUNTO 6:

vieneZafando(Alguien, Serie):-
conoceSerie(Alguien, Serie),
esPopularOPasaronCosasFuertes(Serie),
not(leSpoileo(_, Alguien, Serie)).

esPopularOPasaronCosasFuertes(Serie):-
esPopular(Serie).

esPopularOPasaronCosasFuertes(Serie):-
fuerte(Serie),
cuantosEpisodiosTieneTalTemporada(Serie, _, _).

fuerte(Serie):-
	forall(paso(Serie, _, _, unSuceso), hechoFuerte(Serie, unSuceso)).

:- begin_tests(zafando).

 test(viene_zafando_de, set(Serie == [futurama,himym,got, hoc])) :-
 vieneZafando(juan, Serie).

test(viene_zafando_de, set(PersonaZafante == [nico])):-
vieneZafando(PersonaZafante, starWars).

:- end_tests(zafando).

 %%%%PARTE 2

%PUNTO 1

malaGente(Persona):-
persona(Persona),
forall(leDijo(Persona, Personas, _, _), leSpoileo(Persona, Personas, _)).

malaGente(Persona):-
persona(Persona),
not(conoceSerie(Personas, Serie)),
leSpoileo(Persona, Personas, Serie).

:- begin_tests(malaGente).

test(gaston_es_mala_gente) :-
malaGente(gaston).

test(pedro_no_es_mala_gente) :-
not(malaGente(pedro)).

:- end_tests(malaGente).

 %PUNTO 2

hechoFuerte(Serie, relacion(amorosa, _, _)):-
 ocurrioSuceso(Serie, relacion(amorosa, _, _)).

hechoFuerte(Serie, muerte(_)):-
 ocurrioSuceso(Serie, muerte(_)).

hechoFuerte(Serie, relacion(parentesco, _, _)):-
 ocurrioSuceso(Serie, relacion(parentesco, _, _)).

hechoFuerte(Serie, plotTwist(ListaDePalabras)):-
 not(esCliche(Serie, plotTwist(ListaDePalabras))),
 finalDeTemporada(Serie, plotTwist(ListaDePalabras)).

finalDeTemporada(Serie, Suceso):-
 cuantosEpisodiosTieneTalTemporada(Serie, Cantidad, _),
 paso(Serie, _, Cantidad, Suceso).

esCliche(Serie, plotTwist(ListaDePalabras)):-
 ocurrioSuceso(Serie, plotTwist(ListaDePalabras)),
 ocurrioSuceso(OtraSerie, plotTwist(OtraListaDePalabras)),
 Serie \= OtraSerie,
 forall(member(Palabra, ListaDePalabras), member(Palabra, OtraListaDePalabras)).

esFuerte(Serie, Suceso):-
 generacionDeSeries(Serie),
 paso(Serie, _, _, Suceso),
 hechoFuerte(Serie, Suceso).

:- begin_tests(esFuerte).

 test(es_fuerte_futurama) :-
 esFuerte(futurama, muerte(seymourDiera)).
 test(es_fuerte_starWars) :-
 esFuerte(starWars, muerte(emperor)).
 test(es_fuerte_parentesco1_starWars) :-
 esFuerte(starWars, relacion(parentesco, vader, luke)).
 test(es_fuerte_parentesco2_starWars) :-
 esFuerte(starWars, relacion(parentesco, anakin, rey)).
 test(es_fuerte_amorosa1_himym) :-
 esFuerte(himym, relacion(amorosa, ted, robin)).
 test(es_fuerte_amorosa2_himym) :-
 esFuerte(himym, relacion(amorosa, swarley, robin)).
 test(es_fuerte_twist_got) :-
 esFuerte(got, plotTwist([fuego, boda])).
 test(no_es_fuerte_twist_got) :-
 not(esFuerte(got, plotTwist([suenio,sinPiernas]))).
 test(no_es_fuerte_twist_doctorHouse) :-
 not(esFuerte(doctorHouse, plotTwist([coma,pastillas]))).

:- end_tests(esFuerte).

 %PUNTO 3

esPopular(hoc).

esPopular(Serie):-
 Serie\=hoc,
 popularidad(starWars,PuntosDePopularidad),
 popularidad(Serie,PuntosDePopularidad2),
 PuntosDePopularidad >= PuntosDePopularidad2.

popularidad(Serie, PuntosDePopularidad):-
 cuantosMiranLaSerie(Serie, Cantidad),
 cuantosHablanDeLaSerie(Serie, Cantidad2),
 PuntosDePopularidad is Cantidad * Cantidad2.

cuantosMiranLaSerie(Serie, Cantidad):-
 generacionDeSeries(Serie),
 findall(Alguien, (miraSerie(Alguien, Serie)), MiranSerie),
 length(MiranSerie, Cantidad).

 cuantosHablanDeLaSerie(Serie, Cantidad):-
 generacionDeSeries(Serie),
 findall(Alguien, (leDijo(Alguien, _, Serie, _)), HablanDeLaSerie),
 length(HablanDeLaSerie, Cantidad).

 generacionDeSeries(Serie):-
 quienPlaneaVerQue(_,Serie).
 generacionDeSeries(Serie):-
 miraSerie(_,Serie).
 generacionDeSeries(Serie):-
 paso(Serie,_,_,_).

 %PUNTO 4

amigo(nico, maiu).
amigo(maiu, gaston).
amigo(maiu, juan).
amigo(juan, aye).

leHizoFullSpoil(Persona1, Persona2):-
  leSpoileo(Persona1, Persona2, _),
	Persona1 \= Persona2.

fullSpoil(Persona1, Persona2):-
  amigo(Amigo, Persona2),
  Persona1 \= Persona2,
  fullSpoil(Persona1, Amigo),
  Persona1 \= Amigo.

fullSpoil(Persona1, Persona2):-
  leHizoFullSpoil(Persona1, Persona2).

:- begin_tests(fullSpoil).

  test(nico_full_spoil, set(Alguien == [aye, juan, maiu, gaston])) :-
  fullSpoil(nico, Alguien).

  test(gaston_full_spoil, set(Alguien == [aye, juan, maiu])) :-
  fullSpoil(gaston, Alguien).

:- end_tests(fullSpoil).
