package com.aulabase.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ChildProgressDto {
    private Long childId;
    private String childNombre;
    private List<ChildCourseProgressDto> cursos;
}

