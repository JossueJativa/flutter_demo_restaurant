// ignore_for_file: file_names, unnecessary_null_comparison, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_demo_restaurant/pages/foodByMenu.dart';
import 'package:flutter_demo_restaurant/pages/menuByRestaurant.dart';
import 'package:flutter_demo_restaurant/services/productsByRestaurant.dart';

class MenuItemWidget extends StatefulWidget {
  final String photo;
  final String name;
  final String price;

  const MenuItemWidget({
    required this.photo,
    required this.name,
    required this.price,
  });

  @override
  _MenuItemWidgetState createState() => _MenuItemWidgetState();
}

class _MenuItemWidgetState extends State<MenuItemWidget> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.cyan,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align left and right
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 7.0),
                  child: Image.network(
                    widget.photo,
                    width: 150,
                    height: 150,
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (widget.price != null) ...[
                      Text(
                        widget.price,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (quantity > 0) {
                              setState(() {
                                quantity--;
                              });
                            }
                          },
                        ),
                        Text(
                          '$quantity',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                print('Agregar al carrito: ${widget.name} - Cantidad: $quantity');
              },
              icon: const Icon(Icons.add_shopping_cart),
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantContainerWidget extends StatelessWidget {
  final String photo;
  final String name;
  final String address;
  final VoidCallback onPressed;

  const RestaurantContainerWidget({
    required this.photo,
    required this.name,
    required this.address,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        color: Colors.cyan,
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              photo,
              width: 100,
              height: 100,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    address,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: onPressed,
                    child: const Text(
                      "Ver menús",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CointainerMenuProduct extends StatelessWidget {
  final String photo;
  final String price;
  final String name;
  const CointainerMenuProduct({
    super.key,
    required this.photo,
    required this.price,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return MenuItemWidget(photo: photo, name: name, price: price);
  }
}

class ContainerRestaurants extends StatelessWidget {
  const ContainerRestaurants({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getRestaurants(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No hay datos disponibles.'),
          );
        } else {
          final List<dynamic>? restaurantList = snapshot.data;

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: restaurantList!.length,
            itemBuilder: (BuildContext context, int index) {
              final restaurants = restaurantList[index];
              return RestaurantContainerWidget(
                photo: restaurants['photo'],
                name: restaurants['name'],
                address: restaurants['address'],
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MenuByRestaurant(
                        idRestaurant: restaurants['id'],
                        nameRestaurant: restaurants['name'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}

class CartBoxsMenus extends StatelessWidget {
  final int idRestaurant;
  const CartBoxsMenus({ 
    required this.idRestaurant,
    Key? key 
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return FutureBuilder(
      future: getMenusByRestaurant(idRestaurant),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No hay datos disponibles.'),
          );
        } else {
          final List<dynamic>? menusList = snapshot.data;

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: menusList!.length,
            itemBuilder: (BuildContext context, int index) {
              final menus = menusList[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  color: Colors.cyan,
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        menus['photo'],
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              menus['name'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(context, 
                                  MaterialPageRoute(
                                    builder: (context) => FoodByMenu(
                                      idMenu: menus['id'],
                                      nameMenu: menus['name'],
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                "Ver platos",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

class CartBoxsFoods extends StatelessWidget {
  final int idMenu;
  const CartBoxsFoods({ 
    required this.idMenu,
    Key? key 
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return FutureBuilder(
      future: getFoodsByMenu(idMenu),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No hay datos disponibles.'),
          );
        } else {
          final List<dynamic>? foodList = snapshot.data;

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: foodList!.length,
            itemBuilder: (BuildContext context, int index) {
              final menus = foodList[index];
              return MenuItemWidget(
                photo: menus['photo'],
                name: menus['name'],
                price: menus['price'].toString(),
              );
            },
          );
        }
      },
    );
  }
}