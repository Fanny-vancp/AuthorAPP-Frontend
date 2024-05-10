import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../../model/character_node.dart';
import '../../model/relation_line.dart';

class FamilyTreePainter extends CustomPainter {
  final List<CharacterNode> characters;
  final Set<String> displayedCharacters;
  late List<RelationLine> relationLines = [];

  FamilyTreePainter({
    required this.characters,
    required this.displayedCharacters,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final nodePositions = calculateNodePositions(size);
    final relationLines = calculateRelationLines(nodePositions);

    drawLines(canvas, relationLines);
    drawNodes(canvas, nodePositions);
  }

  Map<CharacterNode, Offset> calculateNodePositions(Size size) {
    final Map<CharacterNode, Offset> nodePositions = {};

    // Position initiale du premier personnage
    double startX = size.width / 2;
    double startY = -250.0;

    const double levelSpacing = 200.0; // Espacement vertical entre les niveaux de l'arbre
    const double siblingSpacing = 200.0; // Espacement horizontal entre les frères et sœurs

    // Fonction récursive pour positionner les nœuds de manière récursive
    void positionNodes(CharacterNode node, double x, double y) {
      nodePositions[node] = Offset(x, y);

      // Positionner le partenaire à côté du personnage s'il en a un
      if (node.married.isNotEmpty && !displayedCharacters.contains(node.married[0])) {
        final CharacterNode spouse = characters.firstWhere((c) => c.name == node.married[0]);
        if (!nodePositions.containsKey(spouse)) {
          final double spouseX = x + siblingSpacing; // Position horizontale à côté du personnage
          positionNodes(spouse, spouseX, y); // Positionner le partenaire
          // Dessiner une ligne horizontale reliant le personnage à son partenaire
          relationLines.add(RelationLine(
            start: Offset(x, y),
            end: Offset(spouseX, y),
            label: "Marié",
          ));
        }
      }

      // Positionner les enfants du personnage
      List<CharacterNode?> childrenNullable = node.children.map((childName) {
        return characters.firstWhereOrNull((character) => character.name == childName);
      }).toList();

      List<CharacterNode> children = childrenNullable.where((child) => child != null).cast<CharacterNode>().toList();
      if (children.isNotEmpty) {
        final double totalWidth = siblingSpacing * (children.length - 1);
        double startX = x - totalWidth / 2;
        final double childY = y + levelSpacing;

        // Positionner les enfants du personnage
        for (int i = 0; i < children.length; i++) {
          // Vérifier si le personnage est déjà positionné
          if (!nodePositions.containsKey(children[i])) {
            double childStartX = startX + siblingSpacing * i;

            // Vérifier si le nombre de parents du child est égal à 2
            if (children[i].parents.length == 1) {
              final CharacterNode parent = characters.firstWhere((c) => c.name == children[i].parents[0]);
              
              // Vérifier si la position du parent est disponible
              if (nodePositions.containsKey(parent)) {
                // Positionner l'enfant juste en dessous du parent
                childStartX = x;
              }
            } else if (children[i].parents.length == 2) {
              final CharacterNode parent1 = characters.firstWhere((c) => c.name == children[i].parents[0]);
              final CharacterNode parent2 = characters.firstWhere((c) => c.name == children[i].parents[1]);
              
              // Vérifier si les positions des parents sont disponibles
              if (nodePositions.containsKey(parent1) && nodePositions.containsKey(parent2)) {
                final double middleX = (x + nodePositions[parent2]!.dx) / 2;
                childStartX = middleX - siblingSpacing / 2; 

                final double parentX = x < nodePositions[parent2]!.dx ? x : nodePositions[parent2]!.dx;
                relationLines.add(RelationLine(
                  start: Offset(parentX, y),
                  end: Offset(parentX, childY),
                  label: '',
                ));
              }
            }

            positionNodes(children[i], childStartX, childY);
          }
        }
      }
      
    }

    // Positionner le premier personnage (racine de l'arbre)
    positionNodes(characters.first, startX, startY);

    return nodePositions;
  }

  List<RelationLine> calculateRelationLines(Map<CharacterNode, Offset> nodePositions) {
    final List<RelationLine> relationLines = [];

    // Parcourir chaque personnage pour trouver ses relations et dessiner les lignes correspondantes
    for (final character in nodePositions.keys) {
      // Vérifier si le personnage a un conjoint et ce conjoint n'a pas encore été affiché
      if (character.married.isNotEmpty && !displayedCharacters.contains(character.married[0])) {
        final CharacterNode spouse = characters.firstWhere((c) => c.name == character.married[0]);
        if (nodePositions.containsKey(spouse)) {
          // Dessiner une ligne de la position du personnage au conjoint
          relationLines.add(RelationLine(
            start: nodePositions[character]!,
            end: nodePositions[spouse]!,
            label: "Marié",
          ));
        }
      }
    }

    // Parcourir chaque personnage pour trouver ses relations et dessiner les lignes correspondantes
    for (final character in nodePositions.keys) {
      // Vérifier si le personnage a des enfants
      if (character.children.isNotEmpty) {
        // Récupérer la position du personnage
        final characterPosition = nodePositions[character]!;
        
        // Récupérer la liste des enfants du personnage
        final children = character.children.map((childName) => characters.firstWhere((c) => c.name == childName)).toList();
        
        // Dessiner une ligne verticale depuis le personnage jusqu'au premier enfant
        final firstChild = children.first;
        final firstChildPosition = nodePositions[firstChild]!;

        if (firstChild.parents.length > 1) {
        // Calculer la position moyenne horizontale de tous les parents
          final middleX = firstChild.parents.map((parentName) => nodePositions[characters.firstWhere((c) => c.name == parentName)]!.dx).reduce((value, element) => value + element) / firstChild.parents.length;
          relationLines.add(RelationLine(start: Offset(middleX, characterPosition.dy), end: Offset(middleX, firstChildPosition.dy), label: ''));
        } else {
          // L'enfant a un seul parent, dessiner simplement une ligne verticale depuis le personnage jusqu'au parent
          relationLines.add(RelationLine(start: Offset(characterPosition.dx, firstChildPosition.dy), end: Offset(characterPosition.dx, firstChildPosition.dy), label: ''));
        }
        
        //final parentPositions = character.parents.map((parentName) => nodePositions[characters.firstWhere((c) => c.name == parentName)]).toList();
        //final double middleX = (parentPositions[0]!.dx + parentPositions[1]!.dx) / 2;
        //relationLines.add(RelationLine(start: characterPosition, end: Offset(middleX, characterPosition.dy), label: ''));

        //final firstChildPosition = nodePositions[children.first]!;
        //relationLines.add(RelationLine(start: characterPosition, end: Offset(characterPosition.dx, firstChildPosition.dy),label: ''));

        // Dessiner des lignes verticales supplémentaires pour les autres enfants
        /*for (int i = 1; i < children.length; i++) {
          final childPosition = nodePositions[children[i]]!;
          relationLines.add(RelationLine(start: Offset(characterPosition.dx, firstChildPosition.dy), end: Offset(characterPosition.dx, childPosition.dy), label: ''));
        }*/
      }
    }

    return relationLines;
  }

  void drawNodes(Canvas canvas, Map<CharacterNode, Offset> nodePositions) {
    final Paint nodePaint = Paint()..color = Colors.blue;
    const double nodeSize = 130.0;
    const double borderRadius = 10.0;
    const TextStyle textStyle = TextStyle(color: Colors.white, fontSize: 12);

    // Dessiner chaque personnage comme un carré avec son nom à sa position respective
    nodePositions.forEach((character, position) {
      // Dessiner le carré
      final Rect nodeRect = Rect.fromCenter(center: position, width: nodeSize, height: nodeSize);
      final RRect roundedRect = RRect.fromRectAndRadius(nodeRect, Radius.circular(borderRadius));
      canvas.drawRRect(roundedRect, nodePaint);

      // Dessiner le nom du personnage au centre du carré
      final TextPainter textPainter = TextPainter(
        text: TextSpan(text: character.name, style: textStyle),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(position.dx - textPainter.width / 2, position.dy - textPainter.height / 2));

      
    });
  }

  void drawLines(Canvas canvas, List<RelationLine> relationLines) {
    final Paint linePaint = Paint()..color = Colors.black..strokeWidth = 2.0;

    // Dessiner chaque ligne de relation entre les nœuds sur le canvas
    relationLines.forEach((line) {
      // Dessiner la ligne
      canvas.drawLine(line.start, line.end, linePaint);

      // Calculer le point milieu de la ligne pour le placement du texte
      final middlePoint = Offset((line.start.dx + line.end.dx) / 2, (line.start.dy + line.end.dy) / 2);

      // Dessiner le texte au-dessus de la ligne (en ajustant le point milieu vers le haut)
      final textPainter = TextPainter(
        text: TextSpan(text: line.label, style: const TextStyle(fontSize: 12.0)),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center, // Utilisation de textAlign pour l'alignement du texte
      );
      textPainter.layout();
      textPainter.paint(canvas, middlePoint - Offset(textPainter.width / 2, textPainter.height + 4)); // Ajustement pour placer le texte au-dessus de la ligne
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}