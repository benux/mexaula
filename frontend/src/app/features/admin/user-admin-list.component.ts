import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { UserService } from '../../core/services/user.service';
import { User } from '../../core/models/user.model';
import { NotificationService } from '../../core/services/notification.service';

@Component({
  selector: 'app-user-admin-list',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './user-admin-list.component.html'
})
export class UserAdminListComponent implements OnInit {
  users: User[] = [];
  isLoading = false;

  constructor(
    private userService: UserService,
    private notificationService: NotificationService
  ) {}

  ngOnInit(): void {
    this.loadUsers();
  }

  loadUsers(): void {
    this.isLoading = true;
    this.userService.getAll().subscribe({
      next: (users) => {
        this.users = users;
        this.isLoading = false;
      },
      error: () => {
        this.isLoading = false;
      }
    });
  }

  toggleStatus(user: User): void {
    this.userService.toggleStatus(user.id, !user.activo).subscribe({
      next: () => {
        this.notificationService.success('Estado actualizado');
        this.loadUsers();
      }
    });
  }
}
