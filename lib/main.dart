import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remote Control Challenge',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 76, 150, 224)),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => GridCubit(),
        child: const GridScreen(),
      ),
    );
  }
}

class GridState {
  final int selectedRow;
  final int selectedCol;

  const GridState({required this.selectedRow, required this.selectedCol});
}

class GridCubit extends Cubit<GridState> {
  static const int gridS = 5;
  GridCubit() : super(const GridState(selectedRow: 0, selectedCol: 0));
  
  void moveUp() {
    if (state.selectedRow > 0) {
      emit(GridState(selectedRow: state.selectedRow - 1, selectedCol: state.selectedCol));
    }
  }
  
  void moveDown() {
    if (state.selectedRow < gridS - 1) {
      emit(GridState(selectedRow: state.selectedRow + 1, selectedCol: state.selectedCol));
    }
  }
  
  void moveLeft() {
    if (state.selectedCol > 0) {
      emit(GridState(selectedRow: state.selectedRow, selectedCol: state.selectedCol - 1));
    }
  }
  
  void moveRight() {
    if (state.selectedCol < gridS - 1) {
      emit(GridState(selectedRow: state.selectedRow, selectedCol: state.selectedCol + 1));
    }
  }
}

class GridScreen extends StatelessWidget {
  const GridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            const Text(
              "Remote Control Challenge",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              flex: 1,
              child: BlocBuilder<GridCubit, GridState>(
                builder: (context, state) {
                  return GridView.builder(
                    itemCount: 25,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      int row = index ~/ 5;
                      int col = index % 5;
                      bool isSelected = row == state.selectedRow && col == state.selectedCol;
                      return Container(
                        decoration: BoxDecoration(
                          color: isSelected ? const Color.fromARGB(255, 162, 43, 154) : Colors.grey,
                          border: Border.all(color: const Color.fromARGB(255, 210, 192, 205)),
                        ),
                        child: Center(
                          child: Text(
                            '(${row + 1}, ${col + 1})',
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  const Text(
                    "Controls",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context.read<GridCubit>().moveUp();
                        },
                        child: const Text("↑"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.read<GridCubit>().moveLeft();
                        },
                        child: const Text("←"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.read<GridCubit>().moveRight();
                        },
                        child: const Text("→"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.read<GridCubit>().moveDown();
                        },
                        child: const Text("↓"),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}