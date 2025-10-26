
struct ImGui_ImplVulkan_InitInfo
{
    uint32_t ApiVersion;
    VkInstance Instance;
    VkPhysicalDevice PhysicalDevice;
    VkDevice Device;
    uint32_t QueueFamily;
    VkQueue Queue;
    VkDescriptorPool DescriptorPool;
    uint32_t DescriptorPoolSize;
    uint32_t MinImageCount;
    uint32_t ImageCount;
    VkPipelineCache PipelineCache;
    VkRenderPass RenderPass;
    uint32_t Subpass;
    VkSampleCountFlagBits MSAASamples;
    bool UseDynamicRendering;
    VkPipelineRenderingCreateInfoKHR PipelineRenderingCreateInfo;
    const VkAllocationCallbacks* Allocator;
    void (*CheckVkResultFn)(VkResult err);
    VkDeviceSize MinAllocationSize;
};
 bool ImGui_ImplVulkan_Init(ImGui_ImplVulkan_InitInfo* info);
 void ImGui_ImplVulkan_Shutdown();
 void ImGui_ImplVulkan_NewFrame();
 void ImGui_ImplVulkan_RenderDrawData(ImDrawData* draw_data, VkCommandBuffer command_buffer, VkPipeline pipeline =                                                                                                                                             ((void*)0)                                                                                                                                                          );
 void ImGui_ImplVulkan_SetMinImageCount(uint32_t min_image_count);
struct ImGui_ImplVulkan_MainPipelineCreateInfo
{
    VkRenderPass RenderPass =                                             ((void*)0)                                                          ;
    uint32_t Subpass = 0;
    VkSampleCountFlagBits MSAASamples = {};
    VkPipelineRenderingCreateInfoKHR PipelineRenderingCreateInfo;
};
 void ImGui_ImplVulkan_CreateMainPipeline(const ImGui_ImplVulkan_MainPipelineCreateInfo& info);
 void ImGui_ImplVulkan_UpdateTexture(ImTextureData* tex);
 VkDescriptorSet ImGui_ImplVulkan_AddTexture(VkSampler sampler, VkImageView image_view, VkImageLayout image_layout);
 void ImGui_ImplVulkan_RemoveTexture(VkDescriptorSet descriptor_set);
 bool ImGui_ImplVulkan_LoadFunctions(uint32_t api_version, PFN_vkVoidFunction(*loader_func)(const char* function_name, void* user_data), void* user_data = nullptr);
struct ImGui_ImplVulkan_RenderState
{
    VkCommandBuffer CommandBuffer;
    VkPipeline Pipeline;
    VkPipelineLayout PipelineLayout;
};
struct ImGui_ImplVulkanH_Frame;
struct ImGui_ImplVulkanH_Window;
 void ImGui_ImplVulkanH_CreateOrResizeWindow(VkInstance instance, VkPhysicalDevice physical_device, VkDevice device, ImGui_ImplVulkanH_Window* wd, uint32_t queue_family, const VkAllocationCallbacks* allocator, int w, int h, uint32_t min_image_count);
 void ImGui_ImplVulkanH_DestroyWindow(VkInstance instance, VkDevice device, ImGui_ImplVulkanH_Window* wd, const VkAllocationCallbacks* allocator);
 VkSurfaceFormatKHR ImGui_ImplVulkanH_SelectSurfaceFormat(VkPhysicalDevice physical_device, VkSurfaceKHR surface, const VkFormat* request_formats, int request_formats_count, VkColorSpaceKHR request_color_space);
 VkPresentModeKHR ImGui_ImplVulkanH_SelectPresentMode(VkPhysicalDevice physical_device, VkSurfaceKHR surface, const VkPresentModeKHR* request_modes, int request_modes_count);
 VkPhysicalDevice ImGui_ImplVulkanH_SelectPhysicalDevice(VkInstance instance);
 uint32_t ImGui_ImplVulkanH_SelectQueueFamilyIndex(VkPhysicalDevice physical_device);
 int ImGui_ImplVulkanH_GetMinImageCountFromPresentMode(VkPresentModeKHR present_mode);
struct ImGui_ImplVulkanH_Frame
{
    VkCommandPool CommandPool;
    VkCommandBuffer CommandBuffer;
    VkFence Fence;
    VkImage Backbuffer;
    VkImageView BackbufferView;
    VkFramebuffer Framebuffer;
};
struct ImGui_ImplVulkanH_FrameSemaphores
{
    VkSemaphore ImageAcquiredSemaphore;
    VkSemaphore RenderCompleteSemaphore;
};
struct ImGui_ImplVulkanH_Window
{
    int Width;
    int Height;
    VkSwapchainKHR Swapchain;
    VkSurfaceKHR Surface;
    VkSurfaceFormatKHR SurfaceFormat;
    VkPresentModeKHR PresentMode;
    VkRenderPass RenderPass;
    bool UseDynamicRendering;
    bool ClearEnable;
    VkClearValue ClearValue;
    uint32_t FrameIndex;
    uint32_t ImageCount;
    uint32_t SemaphoreCount;
    uint32_t SemaphoreIndex;
    ImVector<ImGui_ImplVulkanH_Frame> Frames;
    ImVector<ImGui_ImplVulkanH_FrameSemaphores> FrameSemaphores;
    ImGui_ImplVulkanH_Window()
    {
        memset((void*)this, 0, sizeof(*this));
        PresentMode = (VkPresentModeKHR)~0;
        ClearEnable = true;
    }
};