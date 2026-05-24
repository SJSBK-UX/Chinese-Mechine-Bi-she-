package com.example.medicinedetection.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.medicinedetection.entity.User;
import org.apache.ibatis.annotations.Select;

public interface UserMapper extends BaseMapper<User> {
    @Select("select password from user where username=#{username}")
    User selectByName(String username);


    @Select("select * from user where username = #{username}")
    User selectByUsername(String username);
}
