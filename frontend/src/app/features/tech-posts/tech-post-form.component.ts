﻿import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { TechPostService } from '../../core/services/tech-post.service';
import { TechPostStatus } from '../../core/models/tech-post.model';
@Component({
  selector: 'app-tech-post-form',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './tech-post-form.component.html'
})
export class TechPostFormComponent implements OnInit {
  postForm: FormGroup;
  loading = false;
  error = '';
  isEditMode = false;
  postId?: number;
  statuses: TechPostStatus[] = ['DRAFT', 'PUBLISHED'];
  constructor(
    private readonly fb: FormBuilder,
    private readonly techPostService: TechPostService,
    private readonly router: Router,
    private readonly route: ActivatedRoute
  ) {
    this.postForm = this.fb.group({
      titulo: ['', [Validators.required, Validators.maxLength(200)]],
      resumen: ['', [Validators.required]],
      contenidoMarkdown: ['', [Validators.required]],
      slug: ['', [Validators.required, Validators.maxLength(250)]],
      categoria: [''],
      etiquetas: [''],
      estado: ['DRAFT', Validators.required]
    });
  }
  ngOnInit(): void {
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.isEditMode = true;
      this.postId = Number.parseInt(id, 10);
      this.loadPost(this.postId);
    }
    // Auto-generate slug from title
    this.postForm.get('titulo')?.valueChanges.subscribe(titulo => {
      if (!this.isEditMode && titulo) {
        const slug = this.generateSlug(titulo);
        this.postForm.patchValue({ slug }, { emitEvent: false });
      }
    });
  }
  generateSlug(text: string): string {
    return text
      .toLowerCase()
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '')
      .replace(/[^\w\s-]/g, '')
      .replace(/\s+/g, '-')
      .replace(/-+/g, '-')
      .trim();
  }
  loadPost(id: number): void {
    this.loading = true;
    this.techPostService.getById(id).subscribe({
      next: (post) => {
        // Manejar etiquetas - el backend puede devolver array o string
        let etiquetasString = '';
        const etiquetas = (post as any).etiquetas;

        if (Array.isArray(etiquetas)) {
          etiquetasString = etiquetas.join(', ');
        } else if (etiquetas && typeof etiquetas === 'string') {
          etiquetasString = etiquetas;
        }

        this.postForm.patchValue({
          titulo: post.titulo,
          resumen: post.resumen,
          contenidoMarkdown: post.contenidoMarkdown,
          slug: post.slug,
          categoria: post.categoria,
          etiquetas: etiquetasString,
          estado: post.estado
        });
        this.loading = false;
      },
      error: (err) => {
        this.error = 'Error al cargar la publicación';
        this.loading = false;
        console.error('Error loading post:', err);
      }
    });
  }
  onSubmit(): void {
    if (this.postForm.invalid) {
      return;
    }
    this.loading = true;
    this.error = '';
    const formValue = this.postForm.value;

    // Convert comma-separated tags to array
    const etiquetasValue = formValue.etiquetas || '';
    const etiquetas = etiquetasValue
      .split(',')
      .map((tag: string) => tag.trim())
      .filter((tag: string) => tag.length > 0);

    const postData = {
      titulo: formValue.titulo,
      resumen: formValue.resumen,
      contenidoMarkdown: formValue.contenidoMarkdown,
      slug: formValue.slug,
      categoria: formValue.categoria || null,
      estado: formValue.estado,
      etiquetas
    };

    const request = this.isEditMode
      ? this.techPostService.update(this.postId!, postData)
      : this.techPostService.create(postData);
    request.subscribe({
      next: () => {
        this.router.navigate(['/admin/tech-posts']);
      },
      error: (err) => {
        this.error = this.isEditMode 
          ? 'Error al actualizar la publicación' 
          : 'Error al crear la publicación';
        this.loading = false;
        console.error(err);
      }
    });
  }
  cancel(): void {
    this.router.navigate(['/admin/tech-posts']);
  }
}
