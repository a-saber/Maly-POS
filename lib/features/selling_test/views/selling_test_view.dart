import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/widget/custom_loading.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/categories/manager/get_category/get_category_cubit.dart';
import 'package:pos_app/features/categories/view/widget/category_cubit_builder.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/selling_test/cubit/selling_test_cubit.dart';
import 'package:pos_app/features/selling_test/cubit/selling_test_state.dart';
import 'package:pos_app/features/selling_test/data/models/selling_test_model.dart';

class SellingTestView extends StatefulWidget {
  const SellingTestView({super.key});

  @override
  State<SellingTestView> createState() => _SellingTestViewState();
}

class _SellingTestViewState extends State<SellingTestView> {
  @override
  void initState() {
    GetCategoryCubit.get(context).getCategories();
    super.initState();
  }
  int categoryId = -1;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      SellingTestCubit()
        ..getData(branchId: 1, categoryId: -1),
      child: Scaffold(
        body: BlocConsumer<SellingTestCubit, SellingTestState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            var cubit = SellingTestCubit.get(context);
            return Column(
              children:
              [
                TextFormField(
                  controller: cubit.searchController,
                  onFieldSubmitted: (String? value) {
                    cubit.getData(branchId: 1, categoryId: categoryId, search: value??'');
                  },
                ),
                SizedBox(height: 20,),
                CategoryCubitBuilder(
                  categoriesBuilder: (context, List<CategoryModel> categories) =>
                    SizedBox(
                      height: 100,
                      child: Row(
                        children:
                        [
                          TextButton(
                              onPressed: (){
                                cubit.getData(branchId: 1, categoryId: -1);
                                setState(() {
                                  categoryId = -1;
                                });
                              },
                              child: Text('All')),
                          SizedBox(width: 10,),
                          Expanded(
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: categories.length,
                                itemBuilder: (context, index)=> Padding(
                                  padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: (){
                                              cubit.getData(branchId: 1, categoryId: categories[index].id!);
                                              setState(() {
                                                categoryId = categories[index].id!;
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  height: 80,
                                                  width: 80,
                                                  child: Image.network(
                                                    categories[index].imageUrl ?? '',
                                                    errorBuilder:
                                                        (context, error, stackTrace) =>
                                                            Icon(Icons.error),
                                                  ),
                                                ),
                                                Text(categories[index].name ?? ''),
                                              ],
                                            ),
                                          ),
                                        )),
                          ),
                        ],
                      ),
                        ),
                    categoiresLoading:(context)=> CustomLoading()
                ),
                SizedBox(height: 20,),

                if(state is SellingTestSuccess)
                Builder(
                  builder: (context) {
                    if(SellingTestModel.getIndexByCategoryId(cubit.sellingTestModels, categoryId) == -1)
                    {
                      return Text('no data');
                    }
                    return Expanded(
                      child: ListView.builder(
                          itemCount: cubit.sellingTestModels[SellingTestModel.getIndexByCategoryId(cubit.sellingTestModels, categoryId)].products.length,
                          itemBuilder: (context, index){
                            ProductModel product = cubit.sellingTestModels[SellingTestModel.getIndexByCategoryId(cubit.sellingTestModels, categoryId)]
                                .products[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: (){
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 80,
                                      width: 80,
                                      child: Image.network(
                                        product.imageUrl ?? '',
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                    Text(product.name ?? ''),
                                  ],
                                ),
                              ),
                            );
                          }
                      ),
                    );
                  }
                )



              ],
            );
          },
        ),
      ),
    );
  }
}
