package com.aulabase.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserDto {
    private Long id;
    private String nombre;
    private String apellido;
    private String email;
    private boolean activo;
    private List<String> roles;
}

