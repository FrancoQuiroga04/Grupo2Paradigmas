%PUNTO 1:

quienMiraQue(juan, himym).
quienMiraQue(juan, got).
quienMiraQue(juan, futurama).
quienMiraQue(nico, starWars).
quienMiraQue(nico, got).
quienMiraQue(maiu, starWars).
quienMiraQue(maiu, onePiece).
quienMiraQue(maiu, got).
quienMiraQue(gaston, got).

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


%leDijo/4
leDijo(gaston, maiu, got, relacion(amistad, tyrion, dragon)).
leDijo(nico, maiu, starWars, relacion(parentesco, vader, luke)).
leDijo(nico, juan, got, muerte(tyrion)).
leDijo(aye, juan, got, relacion(amistad, tyrion, john)).
leDijo(aye, maiu, got, relacion(amistad, tyrion, john)).
leDijo(aye, gaston, got, relacion(amistad, tyrion, dragon)).


%PUNTO 3:

%esSpoiler (Serie, Lo que pasó en esa serie).
esSpoiler(starWars, muerte(emperor)).
esSpoiler(starWars, relacion(parentesco, anakin, rey)).
esSpoiler(starWars, relacion(parentesco, vader, luke)).
esSpoiler(futurama, muerte(seymourDiera)).
esSpoiler(himym, relacion(amorosa, swarley, robin)).
esSpoiler(himym, relacion(amorosa, ted, robin)).
esSpoiler(got, relacion(amistad, tyrion, dragon)).

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
quienMiraQue(Nombre1, Serie),
quienMiraQue(Nombre2, Serie),
paso(Serie, _, _, Spoiler),
leDijo(Nombre1, Nombre2, Serie, Spoiler).

leSpoileo(Nombre1, Nombre2, Serie):-
quienMiraQue(Nombre1, Serie),
quienPlaneaVerQue(Nombre2, Serie),
paso(Serie, _, _, Spoiler),
leDijo(Nombre1, Nombre2, Serie, Spoiler).

:- begin_tests(spoilear).

test(alguien_le_spoileo_a_alguien_mas,[true(Serie == got), nondet]) :-
leSpoileo(gaston, maiu, Serie).
test(alguien_le_spoileo_a_alguien_mas,[true(Serie == starWars), nondet]) :-
leSpoileo(nico, maiu, Serie).

:- end_tests(spoilear).


%PUNTO 5:

televidenteResponsable(Televidente):-
quienMiraQue(Televidente, _), not(leSpoileo(Televidente, _, _)).

televidenteResponsable(Televidente):-
quienPlaneaVerQue(Televidente, _), not(leSpoileo(Televidente, _, _)).

:- begin_tests(responsables).

test(alguien_es_televidente_responsable, set(Televidente == [juan, aye, maiu])) :-
televidenteResponsable(Televidente).

:- end_tests(responsables).

%PUNTO 6:

%esFuerte(Serie):- paso(Serie, _, _, muerte(_)).
%esFuerte(Serie):- paso(Serie, _, _, relacion(_)).

vieneZafando(Alguien, Serie):-
quienMiraQue(Alguien, Serie),
paso(Serie, _, _, _),
not(leSpoileo(_, Alguien, Serie)).

vieneZafando(Alguien, Serie):-
quienPlaneaVerQue(Alguien, Serie),
paso(Serie, _, _, _),
not(leSpoileo(_, Alguien, Serie)).


:- begin_tests(zafando).

test(viene_zafando_de,
set(Serie == [futurama,got,himym])) :-
vieneZafando(juan, Serie).
test(viene_zafando_de, set(PersonaZafante == [nico])):-
vieneZafando(PersonaZafante, starWars).
test(viene_zafando_de, set(Serie == [])):-
vieneZafando(maiu, Serie).

:- end_tests(zafando).
