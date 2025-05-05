using AstroFinance.API.Middleware;
using AstroFinance.Application;
using AstroFinance.Infrastructure;
using Microsoft.OpenApi.Models;
using System.Text.Json.Serialization;

var builder = WebApplication.CreateBuilder(args);

// Set environment to Development for easier debugging
builder.Environment.EnvironmentName = "Development";
Console.WriteLine($"Environment: {builder.Environment.EnvironmentName}");

// Add services to the container.
builder.Services.AddControllers()
    .AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.Converters.Add(new JsonStringEnumConverter());
        options.JsonSerializerOptions.DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull;
    });

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { 
        Title = "AstroFinance API", 
        Version = "v1",
        Description = "API for AstroFinance microfinance application"
    });
    
    // Add JWT Authentication to Swagger
    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Description = "JWT Authorization header using the Bearer scheme. Example: \"Authorization: Bearer {token}\"",
        Name = "Authorization",
        In = ParameterLocation.Header,
        Type = SecuritySchemeType.ApiKey,
        Scheme = "Bearer"
    });

    c.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            Array.Empty<string>()
        }
    });
});

// Add CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowSpecificOrigins", policy =>
    {
        // Replace with your frontend's actual origins
        var allowedOrigins = builder.Configuration.GetSection("AllowedOrigins").Get<string[]>();
        
        policy.WithOrigins(allowedOrigins)
              .AllowAnyMethod()
              .AllowAnyHeader()
              .AllowCredentials(); // This is crucial for cookies/auth
        
        // If you need to expose specific headers to the frontend
        policy.WithExposedHeaders("Custom-Header", "Another-Header");
    });
});

// Add application and infrastructure services
builder.Services.AddApplicationServices();
builder.Services.AddInfrastructureServices(builder.Configuration);

var app = builder.Build();

// Configure the HTTP request pipeline.
// Add global exception handling middleware
app.UseMiddleware<ExceptionHandlingMiddleware>();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "AstroFinance API v1");
        c.RoutePrefix = string.Empty; // Set Swagger UI as the root page
    });
}

// Use CORS
app.UseCors("AllowAll");

// Comment out HTTPS redirection for local development
// app.UseHttpsRedirection();

// Add authentication middleware
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

// Add a fallback route to redirect to Swagger
app.MapFallback(context =>
{
    context.Response.Redirect("/");
    return Task.CompletedTask;
});

app.Run();