import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_app/layout/shop_app/cubit/cubit.dart';
import 'package:training_app/layout/shop_app/cubit/states.dart';
import 'package:training_app/models/shop_app/favorites_model.dart';
import 'package:training_app/shared/components/components.dart';
import 'package:training_app/shared/styles/colors.dart';

class FavoritesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return state is! ShopLoadingGetFavoritesState? ListView.separated(
          itemBuilder: (context, index) => buildFavItem(ShopCubit.get(context).favoritesModel!.data!.data[index],context),
          separatorBuilder: (context,index) => myDivider(),
          itemCount: ShopCubit.get(context).favoritesModel!.data!.data.length,
        ): const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildFavItem(FavoritesData model, context) => Padding(
    padding: const EdgeInsets.all(20.0),
    child: SizedBox(
      height: 120.0,
      child: Row(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image(
                image: NetworkImage(model.product!.image),
                width: 120.0,
                height: 120.0,
              ),
              if(model.product!.discount !=0)
                Container(
                  color: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: const Text(
                    'DISCOUNT',
                    style: TextStyle(
                        fontSize: 10.0,
                        color: Colors.white
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20.0,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.product!.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14.0,
                    height: 1.3,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      '${model.product!.price.round()}',
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: defaultColor,
                      ),
                    ),
                    const SizedBox(width: 5.0,),
                    if(model.product!.discount !=0)
                      Text(
                        '${model.product!.oldPrice.round()}',
                        style: const TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    const Spacer(),
                    IconButton(
                      onPressed: (){
                        ShopCubit.get(context).changeFavorites(model.product!.id);
                      },
                      icon: CircleAvatar(
                        radius: 15.0,
                        backgroundColor: ShopCubit.get(context).favorites[model.product!.id]?? true? defaultColor : Colors.grey,
                        child: const Icon(
                          Icons.favorite_border,
                          size: 14.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
