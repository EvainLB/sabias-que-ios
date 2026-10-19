//
//  Reto_3___Sabias_QueUITests.m
//  Reto 3 - Sabias QueUITests
//
//  Created by Enrique Salazar Ruiz on 19/10/26.
//  Copyright © 2026 UVEG. All rights reserved.
//
//  Prueba de interfaz que recorre el flujo del wireframe y guarda
//  una captura de pantalla en cada paso.
//

#import <XCTest/XCTest.h>

@interface Reto_3___Sabias_QueUITests : XCTestCase
@property (nonatomic, strong) XCUIApplication *app;
@end

@implementation Reto_3___Sabias_QueUITests

- (void)setUp {
    self.continueAfterFailure = NO;
    self.app = [[XCUIApplication alloc] init];
    [self.app launch];
}

/// Guarda una captura de pantalla dentro de los resultados de la prueba.
- (void)capturar:(NSString *)nombre {
    XCUIScreenshot *captura = [[XCUIScreen mainScreen] screenshot];
    XCTAttachment *adjunto = [XCTAttachment attachmentWithScreenshot:captura];
    adjunto.name = nombre;
    adjunto.lifetime = XCTAttachmentLifetimeKeepAlways;
    [self addAttachment:adjunto];
}

- (void)testFlujoCompleto {
    XCUIElement *boton = self.app.buttons[@"botonDato"];
    XCUIElement *dato = self.app.staticTexts[@"etiquetaDato"];
    XCUIElement *contador = self.app.staticTexts[@"etiquetaContador"];

    // Paso 1: pantalla de inicio
    XCTAssertTrue([boton waitForExistenceWithTimeout:10]);
    [self capturar:@"1_Inicio"];

    // Paso 2 (inciso b): al tocar el botón aparece un dato
    [boton tap];
    NSString *primerDato = dato.label;
    XCTAssertEqualObjects(contador.label, @"Dato 1 de 5");
    [self capturar:@"2_Primer_dato"];

    // Paso 3 (inciso c): al tocar otra vez aparece un dato diferente
    [boton tap];
    XCTAssertNotEqualObjects(dato.label, primerDato);
    XCTAssertEqualObjects(contador.label, @"Dato 2 de 5");
    [self capturar:@"3_Dato_diferente"];

    // Paso 4 (inciso a): cambiar de categoría
    [self.app.buttons[@"Espacio"] tap];
    [self capturar:@"4_Cambio_de_categoria"];

    // Paso 5: dato de la nueva categoría
    [boton tap];
    XCTAssertEqualObjects(contador.label, @"Dato 1 de 5");
    [self capturar:@"5_Dato_de_Espacio"];
}

@end
