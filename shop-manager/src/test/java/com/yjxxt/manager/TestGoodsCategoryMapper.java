package com.yjxxt.manager;


import com.yjxxt.manager.mapper.GoodsCategoryMapper;
import com.yjxxt.manager.pojo.GoodsCategoryExample;
import com.yjxxt.manager.service.IGoodsCategoryService;
import com.yjxxt.manager.vo.GoodsCategoryVo;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;

@SpringBootTest
public class TestGoodsCategoryMapper {

    @Autowired
    private GoodsCategoryMapper goodsCategoryMapper;

    @Autowired
    private IGoodsCategoryService goodsCategoryService;

    @Test
    public void test01(){
        System.out.println(goodsCategoryMapper.selectByPrimaryKey((short) 1));
    }

    @Test
    public void test02(){
        GoodsCategoryExample goodsCategoryExample=new GoodsCategoryExample();
        goodsCategoryExample.createCriteria()
                .andNameEqualTo("家用电器").andLevelEqualTo((byte)1);
        System.out.println(goodsCategoryMapper.selectByExample(goodsCategoryExample));
    }

    @Test
    public void testSelectCategoryListForView(){
        List<GoodsCategoryVo> gcvList = goodsCategoryService.queryAllGoodsCategories();
        System.out.println(gcvList);
    }

    @Test
    public void testdeleteGoodsCatorie(){
        Short s=847;
        Integer i = goodsCategoryService.deleteGoodsCatorieById(s);
        System.out.println(i);
    }
}
