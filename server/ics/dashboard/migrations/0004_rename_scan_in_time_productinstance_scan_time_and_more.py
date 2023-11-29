# Generated by Django 4.2.6 on 2023-11-28 08:18

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('dashboard', '0003_productinstance_remove_product_quantity_and_more'),
    ]

    operations = [
        migrations.RenameField(
            model_name='productinstance',
            old_name='scan_in_time',
            new_name='scan_time',
        ),
        migrations.RemoveField(
            model_name='product',
            name='max_quantity',
        ),
        migrations.RemoveField(
            model_name='product',
            name='min_quantity',
        ),
        migrations.AddField(
            model_name='product',
            name='quantity',
            field=models.PositiveIntegerField(default=0),
        ),
        migrations.AddField(
            model_name='product',
            name='rop',
            field=models.PositiveIntegerField(default=0, verbose_name='Reorder point'),
        ),
        migrations.AlterField(
            model_name='product',
            name='depth',
            field=models.PositiveIntegerField(verbose_name='Depth in cm'),
        ),
        migrations.AlterField(
            model_name='product',
            name='height',
            field=models.PositiveIntegerField(verbose_name='Height in cm'),
        ),
        migrations.AlterField(
            model_name='product',
            name='weight',
            field=models.DecimalField(decimal_places=3, max_digits=5, verbose_name='Weight in kg'),
        ),
        migrations.AlterField(
            model_name='product',
            name='width',
            field=models.PositiveIntegerField(verbose_name='Width in cm'),
        ),
    ]