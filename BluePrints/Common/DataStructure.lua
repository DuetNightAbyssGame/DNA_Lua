local function NewClass()
    local Class = {}
    Class.New   = function()
        local obj = {}
        obj       = setmetatable(obj, { __index = Class })
        obj:Init()
        return obj
    end
    return Class
end

local Heap = NewClass()

local function Swap(a, b)
    return b, a
end


--小顶堆比较函数
function Heap.MinHeapCompare(a, b)
    if (a < b) then return 1 end
    if (a == b) then return 0 end
    if (a > b) then return -1 end
end

--大顶堆比较函数
function Heap.MaxHeapCompare(a, b)
    if (a < b) then return -1 end
    if (a == b) then return 0 end
    if (a > b) then return 1 end
end

function Heap:Init()
    self.data        = {}
    self.CompareFunc = self.MaxHeapCompare
end

function Heap:SetData(array, compareFunc)
    self.data        = array
    self.CompareFunc = compareFunc
end

function Heap:HeapDown(index)
    local leftChild = index * 2
    local rightChild = index * 2 + 1
    local largest = index

    if leftChild <= #self.data and self.CompareFunc(self.data[leftChild], self.data[largest]) == 1 then
        largest = leftChild
    end

    if rightChild <= #self.data and self.CompareFunc(self.data[rightChild], self.data[largest]) == 1 then
        largest = rightChild
    end

    if largest ~= index then
        self.data[index], self.data[largest] = Swap(self.data[index], self.data[largest])
        self:HeapDown(largest)
    end
end

function Heap:HeapUp(index)

    assert(index >= 1 and index <= #self.data)

    local currentIndex = index
    while (currentIndex > 1) do
        local parentIndex = math.floor(currentIndex / 2)
        local currentData = self.data[currentIndex]
        local parentData  = self.data[parentIndex]
        if (self.CompareFunc(currentData, parentData) == 1) then
            self.data[currentIndex], self.data[parentIndex] = Swap(currentData, parentData)
            currentIndex                                    = parentIndex
        else
            return
        end
    end
end

function Heap:Heapify()
    local startIndex = math.floor(#self.data / 2)
    if (startIndex <= 1) then return end
    for i = startIndex, 1, -1 do
        self:HeapDown(i)
    end
end

function Heap:PushHeap(element)
    self.data[#self.data + 1] = element
    self:HeapUp(#self.data)
end

function Heap:PopHeap()
    if (#self.data == 0) then return end
    if (#self.data == 1) then
        local ret             = self.data[#self.data]
        self.data[#self.data] = nil
        return ret
    end

    self.data[1], self.data[#self.data] = Swap(self.data[1], self.data[#self.data])
    local ret                           = self.data[#self.data]
    self.data[#self.data]               = nil
    self:HeapDown(1)
    return ret
end

function Heap:HeapTop()
    if (#self.data == 0) then return nil end
    return self.data[1]
end

function Heap:Print()
    print("Heap:Print()----------")
    for i = 1, #self.data do
        print(self.data[i])
    end
end

local Deque = NewClass()

function Deque:Init()
    self.data  = {}
    self.start = 1
    self.last  = 1
end

function Deque:SetData(array)
    self.data  = array
    self.start = 1
    self.last  = #array + 1
end

function Deque:IsEmpty()
    return self.start == self.last
end

function Deque:Size()
    return self.last - self.start
end

function Deque:PushFront(element)
    if (self:IsEmpty()) then
        self.data[self.start] = element
        self.last             = self.last + 1
        return
    end
    self.start            = self.start - 1
    self.data[self.start] = element
end

function Deque:PushBack(element)
    self.data[self.last] = element
    self.last            = self.last + 1
end

function Deque:PopBack()
    self.last            = self.last - 1
    local ret            = self.data[self.last]
    self.data[self.last] = nil
    return ret
end

function Deque:PopFront()
    local ret             = self.data[self.start]
    self.data[self.start] = nil
    self.start            = self.start + 1
    return ret
end

function Deque:Get(index)
    assert(self:IsEmpty() == false and index <= self:Size(), "Deque null!!!")
    return self.data[self.start + index - 1]
end

function Deque:Set(index, element)
    assert(self:IsEmpty() == false and index <= self:Size(), "Deque null!!!")
    self.data[self.start + index - 1] = element
end

function Deque:Back()
    return self.data[self.last-1]
end

function Deque:ToArr()
    if(self:IsEmpty()) then
        return {}
    end
    local ret={}
    for i=1,self:Size() do
        table.insert(ret,self:Get(i))
    end
    return ret
end

-- Lua的栈结构
local Stack = NewClass()

function Stack:Init()
    self.DataItems = {}
    self.Size = 0
end

-- 入栈
function Stack:Push(item)
    self.Size = self.Size + 1
    self.DataItems[self.Size] = item
end

-- 出栈
function Stack:Pop()
    if self:IsEmpty() then
        return nil, "Stack is empty"
    end
    local Item = self.DataItems[self.Size]
    self.DataItems[self.Size] = nil
    self.Size = self.Size - 1
    return Item
end

-- 出栈
function Stack:FindAndRemove(item)
    if self:IsEmpty() then
        return nil, "Stack is empty"
    end

    local FindIndex, FindItem = nil, nil
    for index = self.Size, 1, -1 do
        local TestItem = self.DataItems[index]
        if (TestItem == item) then
            FindIndex = index
            FindItem = item
            break
        end
    end

    if (FindIndex ~= nil) then
        for idx = FindIndex, self.Size - 1 do
            self.DataItems[idx] = self.DataItems[idx + 1]
        end
        self.DataItems[self.Size] = nil
        self.Size = self.Size - 1
    end
    return FindItem
end

-- 查看栈顶元素
function Stack:Peek()
    if self:IsEmpty() then
        return nil, "Stack is empty"
    end
    return self.DataItems[self.Size]
end

-- 判断栈是否为空
function Stack:IsEmpty()
    return self.Size == 0
end

-- 获取栈大小
function Stack:GetSize()
    return self.Size
end

-- 清空栈
function Stack:Clear()
    self.DataItems = {}
    self.Size = 0
end

-- 打乱数组
local Utils={}
function Utils:Shuffle(array,count)
    if(#array<2) then return end
    for i=1,#array-1 do
        if(count and i>count) then
            break
        end
        local randIdx = UKismetMathLibrary.RandomIntegerInRange(i,#array)
        DebugPrint("Swap: ",i,randIdx)
        array[i],array[randIdx]=Swap(array[i],array[randIdx])
    end
end

return {
    ["Heap"]  = Heap,
    ["Deque"] = Deque,
    ["Stack"] = Stack,
    ["Utils"] = Utils,
    ["NewClass"] = NewClass,
}



