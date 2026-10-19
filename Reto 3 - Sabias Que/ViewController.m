//
//  ViewController.m
//  Reto 3 - Sabias Que
//
//  Created by Enrique Salazar Ruiz on 19/10/26.
//  Copyright © 2026 UVEG. All rights reserved.
//
//  Funcionamiento:
//  a) El usuario selecciona una de tres categorías (UISegmentedControl).
//  b) Al tocar el botón se muestra un dato curioso de la categoría elegida.
//  c) Al tocar nuevamente el botón se muestra un dato diferente.
//

#import "ViewController.h"

@interface ViewController ()

// Datos: cada categoría tiene su propia lista de datos curiosos.
@property (nonatomic, strong) NSArray<NSString *> *categorias;
@property (nonatomic, strong) NSDictionary<NSString *, NSArray<NSString *> *> *datosPorCategoria;

// Índice del siguiente dato a mostrar en cada categoría.
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *indicePorCategoria;

// Elementos de la interfaz.
@property (nonatomic, strong) UISegmentedControl *selectorCategoria;
@property (nonatomic, strong) UILabel *etiquetaCategoria;
@property (nonatomic, strong) UILabel *etiquetaDato;
@property (nonatomic, strong) UILabel *etiquetaContador;
@property (nonatomic, strong) UIButton *botonDato;

@end

@implementation ViewController

#pragma mark - Ciclo de vida

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cargarDatos];
    [self construirInterfaz];
    [self actualizarEstadoInicial];
}

#pragma mark - Datos

- (void)cargarDatos {
    self.categorias = @[@"Animales", @"Espacio", @"Historia"];

    self.datosPorCategoria = @{
        @"Animales": @[
            @"Los pulpos tienen tres corazones y su sangre es de color azul.",
            @"Las nutrias marinas se toman de las patas mientras duermen para que la corriente no las separe.",
            @"Los koalas pueden dormir hasta 20 horas al día.",
            @"El corazón de una ballena azul puede pesar alrededor de 180 kilogramos.",
            @"Las abejas indican a su colmena dónde hay flores mediante una especie de danza."
        ],
        @"Espacio": @[
            @"Un día en Venus dura más que su año: tarda unos 243 días terrestres en girar sobre sí mismo y 225 en rodear al Sol.",
            @"La luz del Sol tarda unos 8 minutos en llegar a la Tierra.",
            @"Dentro de Júpiter cabrían más de 1,300 planetas del tamaño de la Tierra.",
            @"En la Luna no hay viento, por eso las huellas de los astronautas pueden durar millones de años.",
            @"Saturno es tan poco denso que, en teoría, flotaría en una bañera gigante llena de agua."
        ],
        @"Historia": @[
            @"La Gran Pirámide de Guiza fue la construcción humana más alta del mundo durante casi 3,800 años.",
            @"Cleopatra vivió más cerca en el tiempo de la llegada del ser humano a la Luna que de la construcción de la Gran Pirámide.",
            @"Según la tradición, Tenochtitlan se fundó en 1325 sobre un islote del lago de Texcoco.",
            @"La Torre Eiffel iba a ser desmontada después de 20 años, pero se conservó por su utilidad como antena de radio.",
            @"La guerra más corta de la historia, entre Gran Bretaña y Zanzíbar en 1896, duró menos de 45 minutos."
        ]
    };

    self.indicePorCategoria = [NSMutableDictionary dictionary];
    for (NSString *categoria in self.categorias) {
        self.indicePorCategoria[categoria] = @0;
    }
}

#pragma mark - Interfaz

- (void)construirInterfaz {
    self.view.backgroundColor = [UIColor systemBackgroundColor];

    // Título
    UILabel *titulo = [[UILabel alloc] init];
    titulo.text = @"¿Sabías qué?";
    titulo.font = [UIFont preferredFontForTextStyle:UIFontTextStyleLargeTitle];
    titulo.adjustsFontForContentSizeCategory = YES;
    titulo.textAlignment = NSTextAlignmentCenter;
    titulo.accessibilityTraits = UIAccessibilityTraitHeader;

    // Instrucción
    UILabel *instruccion = [[UILabel alloc] init];
    instruccion.text = @"Elige una categoría";
    instruccion.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    instruccion.adjustsFontForContentSizeCategory = YES;
    instruccion.textColor = [UIColor secondaryLabelColor];
    instruccion.textAlignment = NSTextAlignmentCenter;

    // a) Selector de categoría
    self.selectorCategoria = [[UISegmentedControl alloc] initWithItems:self.categorias];
    self.selectorCategoria.selectedSegmentIndex = 0;
    self.selectorCategoria.accessibilityIdentifier = @"selectorCategoria";
    [self.selectorCategoria addTarget:self
                               action:@selector(categoriaCambiada:)
                     forControlEvents:UIControlEventValueChanged];

    // Tarjeta donde se muestra el dato
    UIView *tarjeta = [[UIView alloc] init];
    tarjeta.backgroundColor = [UIColor secondarySystemBackgroundColor];
    tarjeta.layer.cornerRadius = 16.0;

    self.etiquetaCategoria = [[UILabel alloc] init];
    self.etiquetaCategoria.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.etiquetaCategoria.adjustsFontForContentSizeCategory = YES;
    self.etiquetaCategoria.textColor = [UIColor systemIndigoColor];

    self.etiquetaDato = [[UILabel alloc] init];
    self.etiquetaDato.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
    self.etiquetaDato.adjustsFontForContentSizeCategory = YES;
    self.etiquetaDato.numberOfLines = 0;
    self.etiquetaDato.accessibilityIdentifier = @"etiquetaDato";

    self.etiquetaContador = [[UILabel alloc] init];
    self.etiquetaContador.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.etiquetaContador.adjustsFontForContentSizeCategory = YES;
    self.etiquetaContador.textColor = [UIColor secondaryLabelColor];
    self.etiquetaContador.accessibilityIdentifier = @"etiquetaContador";

    UIStackView *pilaTarjeta = [[UIStackView alloc] initWithArrangedSubviews:@[
        self.etiquetaCategoria, self.etiquetaDato, self.etiquetaContador
    ]];
    pilaTarjeta.axis = UILayoutConstraintAxisVertical;
    pilaTarjeta.spacing = 12.0;
    pilaTarjeta.translatesAutoresizingMaskIntoConstraints = NO;
    [tarjeta addSubview:pilaTarjeta];

    // b) y c) Botón para mostrar un dato
    self.botonDato = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.botonDato setTitle:@"Muéstrame un dato" forState:UIControlStateNormal];
    self.botonDato.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.botonDato.titleLabel.adjustsFontForContentSizeCategory = YES;
    self.botonDato.backgroundColor = [UIColor systemIndigoColor];
    [self.botonDato setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.botonDato.layer.cornerRadius = 12.0;
    self.botonDato.accessibilityIdentifier = @"botonDato";
    [self.botonDato addTarget:self
                       action:@selector(mostrarDato:)
             forControlEvents:UIControlEventTouchUpInside];

    // Pila principal
    UIStackView *pilaPrincipal = [[UIStackView alloc] initWithArrangedSubviews:@[
        titulo, instruccion, self.selectorCategoria, tarjeta, self.botonDato
    ]];
    pilaPrincipal.axis = UILayoutConstraintAxisVertical;
    pilaPrincipal.spacing = 20.0;
    pilaPrincipal.translatesAutoresizingMaskIntoConstraints = NO;
    [pilaPrincipal setCustomSpacing:8.0 afterView:titulo];
    [self.view addSubview:pilaPrincipal];

    UILayoutGuide *margen = self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [pilaPrincipal.topAnchor constraintEqualToAnchor:margen.topAnchor constant:32.0],
        [pilaPrincipal.leadingAnchor constraintEqualToAnchor:margen.leadingAnchor constant:24.0],
        [pilaPrincipal.trailingAnchor constraintEqualToAnchor:margen.trailingAnchor constant:-24.0],

        [pilaTarjeta.topAnchor constraintEqualToAnchor:tarjeta.topAnchor constant:20.0],
        [pilaTarjeta.leadingAnchor constraintEqualToAnchor:tarjeta.leadingAnchor constant:20.0],
        [pilaTarjeta.trailingAnchor constraintEqualToAnchor:tarjeta.trailingAnchor constant:-20.0],
        [pilaTarjeta.bottomAnchor constraintEqualToAnchor:tarjeta.bottomAnchor constant:-20.0],
        [tarjeta.heightAnchor constraintGreaterThanOrEqualToConstant:200.0],

        [self.selectorCategoria.heightAnchor constraintGreaterThanOrEqualToConstant:36.0],
        [self.botonDato.heightAnchor constraintGreaterThanOrEqualToConstant:52.0]
    ]];
}

#pragma mark - Acciones

/// a) Se ejecuta cuando el usuario cambia de categoría.
- (void)categoriaCambiada:(UISegmentedControl *)sender {
    [self actualizarEstadoInicial];
}

/// b) y c) Muestra el siguiente dato de la categoría seleccionada.
/// Cada toque avanza al siguiente dato, así que nunca se repite el anterior.
- (void)mostrarDato:(UIButton *)sender {
    NSString *categoria = [self categoriaSeleccionada];
    NSArray<NSString *> *datos = self.datosPorCategoria[categoria];
    NSInteger indice = [self.indicePorCategoria[categoria] integerValue];

    self.etiquetaDato.text = datos[indice];
    self.etiquetaContador.text = [NSString stringWithFormat:@"Dato %ld de %lu",
                                  (long)(indice + 1), (unsigned long)datos.count];

    // Al llegar al último dato se vuelve a empezar.
    self.indicePorCategoria[categoria] = @((indice + 1) % datos.count);

    [self.botonDato setTitle:@"Otro dato" forState:UIControlStateNormal];

    // Pequeña animación para que se note el cambio de dato.
    self.etiquetaDato.alpha = 0.0;
    [UIView animateWithDuration:0.25 animations:^{
        self.etiquetaDato.alpha = 1.0;
    }];

    // Anuncia el nuevo dato a VoiceOver.
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, self.etiquetaDato.text);
}

#pragma mark - Utilidades

- (NSString *)categoriaSeleccionada {
    return self.categorias[self.selectorCategoria.selectedSegmentIndex];
}

- (void)actualizarEstadoInicial {
    NSString *categoria = [self categoriaSeleccionada];
    self.etiquetaCategoria.text = categoria;
    self.etiquetaDato.text = [NSString stringWithFormat:
        @"Toca el botón para descubrir un dato curioso sobre %@.", [categoria lowercaseString]];
    self.etiquetaContador.text = @"";
    [self.botonDato setTitle:@"Muéstrame un dato" forState:UIControlStateNormal];
}

@end
