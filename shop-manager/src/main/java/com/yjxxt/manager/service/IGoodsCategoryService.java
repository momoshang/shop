package com.yjxxt.manager.service;

import com.yjxxt.manager.pojo.GoodsCategory;
import com.yjxxt.manager.vo.GoodsCategoryVo;


import java.util.List;

public interface IGoodsCategoryService {

    /**
     * 根据父类id 查询子类数据
     * @param parentId
     * @return
     */
    public List<GoodsCategory> queryGoodsCategoriesByParentId(Short parentId);


    /**
     * 添加商品分类
     * @param goodsCategory
     */
    public void saveGoodsCategory(GoodsCategory goodsCategory);

    /**
     * 查询所有商品分类数据
     * @return
     */
    List<GoodsCategoryVo> queryAllGoodsCategories();

    /**
     *删除商品分类数据
     * @author hongbin
     * @param
     * @return
     */
    Integer deleteGoodsCatorieById(Short id);

    /**
     * 商品分类-查询所有商品分类
     * @return
     */
    List<GoodsCategory> selectCategoryList();

}
