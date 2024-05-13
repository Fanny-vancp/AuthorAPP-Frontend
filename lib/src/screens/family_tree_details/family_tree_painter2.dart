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

    // Init position first character
    double startX = size.width / 2;
    double startY = -250;

    const double levelSpacing = 250.0; // vertical space
    const double columnSpacing = 200.0; // horizontal space

    // Fonction récursive pour positionner les nœuds de manière récursive
    void positionNodes(CharacterNode node, double x, double y) {
      nodePositions[node] = Offset(x, y);

      // Positon children with one parents
      List<CharacterNode?> childrenNullable = node.children.map((childName) {
        return characters.firstWhereOrNull((character) => character.name == childName);
      }).toList();

      List<CharacterNode> childrenOneParent = childrenNullable.where((child) => child != null && child.parents.length == 1).cast<CharacterNode>().toList();

      if (childrenOneParent.isNotEmpty) {
        final double startChildY = calculateY(childrenOneParent[0], levelSpacing, startY);
        double startChildX = x - ((columnSpacing * (childrenOneParent.length - 1)) / 2);

        for (int i = 0; i < childrenOneParent.length; i++) {
          CharacterNode child = childrenOneParent[i];
          double nextXPosition = getNextAvailableXPosition(startChildX, startChildY, nodePositions, columnSpacing);
          if (nextXPosition!=startChildX) {
            /*double totalChildrenX = columnSpacing * (childrenOneParent.length-1);
            x = nextXPosition + (totalChildrenX / 2);
            nodePositions[node] = Offset(x, y);*/

            double totalChildrenX = columnSpacing * (childrenOneParent.length-1);
            double deltaX  = nextXPosition + (totalChildrenX / 2);
            updateNodeAndDescendantsXPositions(node, deltaX, nodePositions, columnSpacing);
          }
          positionNodes(child, nextXPosition, startChildY);
          startChildX = nextXPosition + columnSpacing;
        }
      }
    }

    // Positionner le premier personnage (racine de l'arbre)
    startY = calculateY(characters.first, levelSpacing, startY);
    positionNodes(characters.first, startX, startY);

    return nodePositions;
  }

  void updateNodeAndDescendantsXPositions(CharacterNode node, double deltaX, Map<CharacterNode, Offset> nodePositions, double columnSpacing) {
    nodePositions[node] = Offset(deltaX, nodePositions[node]!.dy);

    if (node.parents.isNotEmpty) {
      List<CharacterNode?> parentsNullable = node.parents.map((parentName) {
        return characters.firstWhereOrNull((character) => character.name == parentName);
      }).toList();
      CharacterNode parent = parentsNullable.first!;

      List<CharacterNode?> childrenNullable = node.parents.map((childName) {
        return characters.firstWhereOrNull((character) => character.name == childName);
      }).toList();
      CharacterNode firstChild = childrenNullable.first!;

      double totalChildrenX = columnSpacing * (parent.children.length-1);
      double deltaX  = nodePositions[firstChild]!.dx + (totalChildrenX / 2);
      updateNodeAndDescendantsXPositions(parent, deltaX, nodePositions, columnSpacing);
    }
  }

  double calculateY(CharacterNode node, double spaceBetween, double startY) {
    return (node.level * spaceBetween) + startY;
  }

  double getNextAvailableXPosition(double initialX, double y, Map<CharacterNode, Offset> nodePositions, double columnSpacing) {
    double newX = initialX;
    while (nodePositions.values.any((position) => (position.dx == newX && position.dy == y))) {
      newX += columnSpacing; 
    }
    return newX;
  }

  List<RelationLine> calculateRelationLines(Map<CharacterNode, Offset> nodePositions) {
    final List<RelationLine> relationLines = [];

    for (final character in nodePositions.keys) {
      // relation with children who had only one parent
      List<CharacterNode?> childrenNullable = character.children.map((childName) {
        return characters.firstWhereOrNull((character) => character.name == childName);
      }).toList();

      List<CharacterNode> childrenOneParent = childrenNullable.where((child) => child != null && child.parents.length == 1).cast<CharacterNode>().toList();

      if (childrenOneParent.isNotEmpty) {
        // get position character
        final characterPosition = nodePositions[character]!;
        relationLines.add(
          RelationLine(
            start: Offset(characterPosition.dx, characterPosition.dy),
            end: Offset(characterPosition.dx, characterPosition.dy + 140),
            label: '',
          ),
        );

        final firstChildPosition = nodePositions[childrenOneParent[0]]!;
        final lastChildPosition = nodePositions[childrenOneParent[childrenOneParent.length - 1]]!;

        for (int i = 0; i < childrenOneParent.length; i++) {
          final childPosition = nodePositions[childrenOneParent[i]]!;
          // verticale
          relationLines.add(
            RelationLine(
              start: Offset(childPosition.dx, characterPosition.dy + 140),
              end: Offset(childPosition.dx, childPosition.dy),
              label: '',
            ),
          );

          // horizontale
          relationLines.add(
            RelationLine(
              start: Offset(firstChildPosition.dx, characterPosition.dy + 140),
              end: Offset(lastChildPosition.dx, characterPosition.dy + 140),
              label: '',
            ),
          );
        }
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
